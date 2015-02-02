//
//  LBXAppDelegate.m
//  Longboxed-iOS
//
//  Created by johnrhickey on 6/29/14.
//  Copyright (c) 2014 Longboxed. All rights reserved.
//
#import "LBXDatabaseManager.h"
#import "LBXAppDelegate.h"
#import "LBXDashboardViewController.h"
#import "LBXClient.h"
#import "LBXLogging.h"
#import "LBXControllerServices.h"
#import "UIColor+LBXCustomColors.h"

#import "UIFont+LBXCustomFonts.h"
#import "PaintCodeImages.h"

// Logging
#import "DDLog.h"
#import "DDNSLoggerLogger.h"
#import "DDTTYLogger.h"
#import "NSLogger.h"
#import "PSDDFormatter.h"

#import <Crashlytics/Crashlytics.h>
#import <CrashReporter/CrashReporter.h>
#import <DropboxSDK/DropboxSDK.h>
#import "FAKFontAwesome.h"
#import "TSMessage.h"
#import "OnboardingContentViewController.h"
#import "LBXLoginViewController.h"
#import "LBXSignupViewController.h"
#import "SIAlertView.h"

static NSString * const kUserHasOnboardedKey = @"user_has_onboarded";


@interface LBXAppDelegate ()

@property (nonatomic) LBXDashboardViewController *dashboardViewController;

@end

@implementation LBXAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // TODO: Remove dropbox stuff
    NSString *APIKeyPath = [[NSBundle mainBundle] pathForResource:@"keys.txt" ofType:@""];
    
    NSString *APIKeyValueDirty = [NSString stringWithContentsOfFile:APIKeyPath
                                                           encoding:NSUTF8StringEncoding
                                                              error:NULL];
    
    // Strip whitespace to clean the API key stdin
    NSString *APIKeyValues = [APIKeyValueDirty stringByTrimmingCharactersInSet:
                              [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSArray *APIKeyArray = [APIKeyValues componentsSeparatedByString:@"\n"];
    NSString* appKey = APIKeyArray[0];
    NSString* appSecret = APIKeyArray[1];
    NSString *root = kDBRootDropbox;
    
    DBSession *dbSession = [[DBSession alloc]
                            initWithAppKey:appKey
                            appSecret:appSecret
                            root:root]; // either kDBRootAppFolder or kDBRootDropbox
    [DBSession setSharedSession:dbSession];
    
    // Fetch in the background as often as possible
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    [LBXDatabaseManager setupRestKit];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // OnBoard if necessary
    BOOL userHasOnboarded = [[NSUserDefaults standardUserDefaults] boolForKey:kUserHasOnboardedKey];
    
    // If the user has already onboarded, just set up the normal root view controller
    // for the application, but don't animate it because there's no transition in this case
    if (userHasOnboarded) {
        [self setupNormalRootViewControllerAnimated:NO];
    }
    else {
        self.window.rootViewController = [self generateOnboardingVC];
    }
    
    [self.window makeKeyAndVisible];
    
    
    // Set the font for all UIBarButtonItems
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(0.0, 1.0);
    shadow.shadowColor = [UIColor whiteColor];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor blackColor],
       NSShadowAttributeName:shadow,
       NSFontAttributeName:[UIFont navSubtitleFont]
       }
     forState:UIControlStateNormal];
    
    // initialize before HockeySDK, so the delegate can access the file logger!
    _fileLogger = [[DDFileLogger alloc] init];
    _fileLogger.maximumFileSize = (1024 * 500); // 500 KByte
    _fileLogger.logFileManager.maximumNumberOfLogFiles = 1;
    [_fileLogger rollLogFileWithCompletionBlock:nil];
    [DDLog addLogger:_fileLogger];
    
    // Crashlytics
    [Crashlytics startWithAPIKey:@"16ebe072876d720b57b612526b0b6f214e2c3cf5"];
    
    // Hockey app needs to be the last 3rd party integration in this method
    // Alpha Version
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"4064359702d9b0088c5ccb88d7d897b5"];
    
    // add Xcode console logger if not running in the App Store
    if (![[BITHockeyManager sharedHockeyManager] isAppStoreEnvironment]) {
        PSDDFormatter *psLogger = [[PSDDFormatter alloc] init];
        [[DDTTYLogger sharedInstance] setLogFormatter:psLogger];
        
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        [DDLog addLogger:[DDNSLoggerLogger sharedInstance]];
    }
    
    [LBXLogging beginLogging];
    
    
    PLCrashReporter *crashReporter = [PLCrashReporter sharedReporter];
    NSError *error;
    
    // Check if we previously crashed
    if ([crashReporter hasPendingCrashReport])
        [LBXControllerServices showCrashAlertWithDelegate:_dashboardViewController];
    
    // Enable the Crash Reporter
    if (![crashReporter enableCrashReporterAndReturnError: &error])
        [LBXLogging logMessage:[NSString stringWithFormat:@"Warning: Could not enable crash reporter: %@", error]];
    
    // Automatically send crash reports
    [[BITHockeyManager sharedHockeyManager].crashManager setCrashManagerStatus:BITCrashManagerStatusAutoSend];
    
    [[BITHockeyManager sharedHockeyManager] setDelegate:self];
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
    
    return YES;
}

- (void)externallySetRootViewController:(id)viewController {
    [UIView transitionWithView:self.window duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        self.window.rootViewController = viewController;
    } completion:nil];

}

- (void)setupNormalRootViewControllerAnimated:(BOOL)animated {
    // Override point for customization after application launch.
    _dashboardViewController = [LBXDashboardViewController new];
    
    if (animated) {
        [UIView transitionWithView:self.window duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:_dashboardViewController];
        } completion:nil];
    }
    // otherwise just set the root view controller normally without animation
    else {
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:_dashboardViewController];
    }
    
    _dashboardViewController.managedObjectContext = [NSManagedObjectContext MR_defaultContext];
}

- (void)handleOnboardingCompletion {
    // Set that we have completed onboarding so we only do it once.
    //[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserHasOnboardedKey];
    
    // animate the transition to the main application
    [self setupNormalRootViewControllerAnimated:YES];
}

// TODO: Remove dropbox stuff
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url
  sourceApplication:(NSString *)source annotation:(id)annotation {
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            NSLog(@"App linked successfully!");
            // At this point you can start making API calls
        }
        return YES;
    }
    // Add whatever other url handling code your app requires here
    return NO;
}

// get the log content with a maximum byte size
- (NSString *) getLogFilesContentWithMaxSize:(NSInteger)maxSize {
    NSMutableString *description = [NSMutableString string];
    
    NSArray *sortedLogFileInfos = [[_fileLogger logFileManager] sortedLogFileInfos];
    NSInteger count = [sortedLogFileInfos count];
    // we start from the last one
    for (NSInteger index = count - 1; index >= 0; index--) {
        DDLogFileInfo *logFileInfo = [sortedLogFileInfos objectAtIndex:index];
        NSData *logData = [[NSFileManager defaultManager] contentsAtPath:[logFileInfo filePath]];
        if ([logData length] > 0) {
            NSString *result = [[NSString alloc] initWithBytes:[logData bytes]
                                                        length:[logData length]
                                                      encoding: NSUTF8StringEncoding];
            
            [description appendString:result];
        }
    }
    
    if ((long)[description length] > maxSize) {
        description = (NSMutableString *)[description substringWithRange:NSMakeRange([description length]-maxSize-1, maxSize)];
    }
    
    return description;
}

#pragma mark - BITCrashManagerDelegate

- (NSString *)applicationLogForCrashManager:(BITCrashManager *)crashManager {
    NSString *description = [self getLogFilesContentWithMaxSize:5000]; // 5000 bytes should be enough!
    if ([description length] == 0) {
        return nil;
    } else {
        return description;
    }
}

#pragma mark - Background Refreshing

// Background refresh
-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    LBXClient *client = [LBXClient new];
    // Fetch popular issues
    [client fetchPopularIssuesWithCompletion:^(NSArray *popularIssuesArray, RKObjectRequestOperation *response, NSError *error) {
        [LBXLogging logMessage:@"Fetched popular titles"];
        if (!error) {
            for (LBXIssue *issue in popularIssuesArray) {
                [client fetchTitle:issue.title.titleID withCompletion:^(LBXTitle *title, RKObjectRequestOperation *response, NSError *error) {
                    if (error) {
                        [LBXLogging logMessage:@"Failed fetching popular titles"];
                        completionHandler(UIBackgroundFetchResultFailed);
                    }
                }];
            }
        }
        else {
            [LBXLogging logMessage:@"Failed fetching titles"];
            completionHandler(UIBackgroundFetchResultFailed);
        }
    }];
    
    if ([LBXControllerServices isLoggedIn]) {
        // Fetch the users bundles
        [client fetchLatestBundleWithCompletion:^(LBXBundle *bundle, RKObjectRequestOperation *response, NSError *error) {
            if (!error) {
                [LBXLogging logMessage:@"Fetched users latest bundle"];
                completionHandler(UIBackgroundFetchResultNewData);
            }
            else {
                [LBXLogging logMessage:@"Failed fetching users latest bundle"];
                completionHandler(UIBackgroundFetchResultFailed);
            }
        }];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [MagicalRecord cleanUp];
}


// http://oleb.net/blog/2009/09/managing-the-network-activity-indicator/
- (void)setNetworkActivityIndicatorVisible:(BOOL)setVisible {
    static NSUInteger kNetworkIndicatorCount = 0;
    
    if (setVisible) {
        kNetworkIndicatorCount++;
    }
    else {
        kNetworkIndicatorCount--;
    }
    
    // Display the indicator as long as our static counter is > 0.
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:(kNetworkIndicatorCount > 0)];
    });
}

- (void)setAPIErrorMessageVisible:(BOOL)setVisible withError:(NSError *)error {
    NSString *localizedErrorString = error.userInfo[@"NSLocalizedDescription"];
    NSString *errorMessage = (localizedErrorString) ? [localizedErrorString stringByReplacingCharactersInRange:NSMakeRange(0,1) withString:[[localizedErrorString substringToIndex:1] uppercaseString]] : @"Unable to connect to Longboxed servers.";

    [TSMessage addCustomDesignFromFileWithName:@"LBXErrorDesign.json"];
    
    [TSMessage showNotificationInViewController:self.window.rootViewController
                                          title:@"Error"
                                       subtitle:errorMessage
                                          image:nil
                                           type:TSMessageNotificationTypeError
                                       duration:3.0f
                                       callback:nil
                                    buttonTitle:nil 
                                 buttonCallback:nil
                                     atPosition:TSMessageNotificationPositionNavBarOverlay
                           canBeDismissedByUser:YES];
}

#pragma mark OnBoarding

//- (OnboardingViewController *)generateFirstDemoVC {
//    OnboardingContentViewController *firstPage = [OnboardingContentViewController contentWithTitle:@"What A Beautiful Photo" body:@"This city background image is so beautiful." image:[UIImage imageNamed:@"blue"] buttonText:@"Enable Location Services" action:^{
//        [[[UIAlertView alloc] initWithTitle:nil message:@"Here you can prompt users for various application permissions, providing them useful information about why you'd like those permissions to enhance their experience, increasing your chances they will grant those permissions." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//    }];
//    
//    OnboardingContentViewController *secondPage = [OnboardingContentViewController contentWithTitle:@"I'm so sorry" body:@"I can't get over the nice blurry background photo." image:[UIImage imageNamed:@"red"] buttonText:@"Connect With Facebook" action:^{
//        [[[UIAlertView alloc] initWithTitle:nil message:@"Prompt users to do other cool things on startup. As you can see, hitting the action button on the prior page brought you automatically to the next page. Cool, huh?" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
//    }];
//    secondPage.movesToNextViewController = YES;
//    
//    OnboardingContentViewController *thirdPage = [OnboardingContentViewController contentWithTitle:@"Seriously Though" body:@"Kudos to the photographer." image:[UIImage imageNamed:@"yellow"] buttonText:@"Get Started" action:^{
//        [self handleOnboardingCompletion];
//    }];
//    
//    OnboardingViewController *onboardingVC = [OnboardingViewController onboardWithBackgroundImage:[UIImage imageNamed:@"street"] contents:@[firstPage, secondPage, thirdPage]];
//    onboardingVC.shouldFadeTransitions = YES;
//    onboardingVC.fadePageControlOnLastPage = YES;
//    
//    // If you want to allow skipping the onboarding process, enable skipping and set a block to be executed
//    // when the user hits the skip button.
//    onboardingVC.allowSkipping = YES;
//    onboardingVC.skipHandler = ^{
//        [self handleOnboardingCompletion];
//    };
//    
//    return onboardingVC;
//}

- (OnboardingViewController *)generateOnboardingVC {
    OnboardingContentViewController *firstPage = [[OnboardingContentViewController alloc] initWithTitle:@"Welcome to Longboxed" body:@"Never miss an issue again." image:nil buttonText:@"How it works" action:^{
            [((OnboardingViewController *)self.window.rootViewController) moveNextPage];
        }];
    firstPage.iconHeight = self.window.frame.size.height/4 - 100;
    firstPage.titleFontName = [UIFont onboardingTitleFont].fontName;
    firstPage.titleFontSize = [UIFont onboardingTitleFont].pointSize;
    firstPage.bodyFontName = [UIFont onboardingBodyFont].fontName;
    firstPage.bodyFontSize = [UIFont onboardingBodyFont].pointSize;
    firstPage.buttonFontName = [UIFont onboardingButtonFont].fontName;
    firstPage.buttonFontSize = [UIFont onboardingButtonFont].pointSize;
    
    int bookSize = 1000;
    FAKFontAwesome *bookIcon = [FAKFontAwesome bookIconWithSize:bookSize];
    [bookIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *bookImage = [bookIcon imageWithSize:CGSizeMake(bookSize, bookSize)];
    
    OnboardingContentViewController *secondPage = [[OnboardingContentViewController alloc] initWithTitle:@"All Your Favorites" body:@"Browse or search for thousands of comics. All titles are cataloged and tracked." image:bookImage buttonText:nil action:nil];

    secondPage.topPadding = 90;
    secondPage.iconHeight = self.window.frame.size.height/7;
    secondPage.iconWidth = self.window.frame.size.height/7;
    
    secondPage.titleFontName = [UIFont onboardingTitleFont].fontName;
    secondPage.titleFontSize = [UIFont onboardingTitleFont].pointSize;
    secondPage.bodyFontName = [UIFont onboardingBodyFont].fontName;
    secondPage.bodyFontSize = [UIFont onboardingBodyFont].pointSize;
    secondPage.buttonFontName = [UIFont onboardingButtonFont].fontName;
    secondPage.buttonFontSize = [UIFont onboardingButtonFont].pointSize;
    
    int listSize = 1000;
    FAKFontAwesome *listIcon = [FAKFontAwesome listIconWithSize:listSize];
    [listIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *listImage = [listIcon imageWithSize:CGSizeMake(listSize, listSize)];
    
    OnboardingContentViewController *thirdPage = [[OnboardingContentViewController alloc] initWithTitle:@"Create A Pull List" body:@"Add your favoite comics to the pull list to keep track of what issues are coming up." image:listImage buttonText:nil action:nil];
    
    thirdPage.topPadding = 90;
    thirdPage.iconHeight = self.window.frame.size.height/7;
    thirdPage.iconWidth = self.window.frame.size.height/7;
    
    thirdPage.titleFontName = [UIFont onboardingTitleFont].fontName;
    thirdPage.titleFontSize = [UIFont onboardingTitleFont].pointSize;
    thirdPage.bodyFontName = [UIFont onboardingBodyFont].fontName;
    thirdPage.bodyFontSize = [UIFont onboardingBodyFont].pointSize;
    thirdPage.buttonFontName = [UIFont onboardingButtonFont].fontName;
    thirdPage.buttonFontSize = [UIFont onboardingButtonFont].pointSize;
    
    int bundleSize = 1000;
    FAKFontAwesome *bundleIcon = [FAKFontAwesome archiveIconWithSize:bundleSize];
    [bundleIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage *bundleImage = [bundleIcon imageWithSize:CGSizeMake(bundleSize, bundleSize)];
    
    OnboardingContentViewController *fourthPage = [[OnboardingContentViewController alloc] initWithTitle:@"Check Your Bundles" body:@"Weekly bundles are created from the comics in your pull list. Check your bundles to see what to read!" image:bundleImage buttonText:nil action:nil];
    
    fourthPage.topPadding = 90;
    fourthPage.iconHeight = self.window.frame.size.height/7;
    fourthPage.iconWidth = self.window.frame.size.height/7;
    
    fourthPage.titleFontName = [UIFont onboardingTitleFont].fontName;
    fourthPage.titleFontSize = [UIFont onboardingTitleFont].pointSize;
    fourthPage.bodyFontName = [UIFont onboardingBodyFont].fontName;
    fourthPage.bodyFontSize = [UIFont onboardingBodyFont].pointSize;
    fourthPage.buttonFontName = [UIFont onboardingButtonFont].fontName;
    fourthPage.buttonFontSize = [UIFont onboardingButtonFont].pointSize;

    if (![LBXControllerServices isLoggedIn]) {
        firstPage.bottomPadding = 44;
        secondPage.bottomPadding = firstPage.bottomPadding;
        thirdPage.bottomPadding = firstPage.bottomPadding;
        fourthPage.bottomPadding = firstPage.bottomPadding;
    }
    
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *moviePath = [bundle pathForResource:@"OnboardMovie" ofType:@"mp4"];
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    
    OnboardingViewController *onboardingVC = [[OnboardingViewController alloc] initWithBackgroundVideoURL:movieURL contents:@[firstPage, secondPage, thirdPage, fourthPage]];
    onboardingVC.shouldFadeTransitions = YES;
    onboardingVC.shouldMaskBackground = YES;
    onboardingVC.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    onboardingVC.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    onboardingVC.allowSkipping = YES;
    onboardingVC.skipButton.titleLabel.font = [UIFont onboardingSkipButtonFont];
    if (![LBXControllerServices isLoggedIn]) {
        onboardingVC.loginButtonFont = [UIFont onboardingLoginAndSignupButtonFont];
        onboardingVC.signupButtonFont = [UIFont onboardingLoginAndSignupButtonFont];
        onboardingVC.underPagingPadding = 48;
    }
    else {
        onboardingVC.hideSignupAndLoginButtons = YES;
    }
    
    onboardingVC.signupHandler = ^{
        LBXSignupViewController *signupController = [LBXSignupViewController new];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:signupController];
        [self.window.rootViewController presentViewController:navigationController animated:YES completion:nil];
    };
    onboardingVC.loginHandler = ^{
        LBXLoginViewController *loginController = [LBXLoginViewController new];
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:loginController];
        [self.window.rootViewController presentViewController:navigationController animated:YES completion:nil];
    };
    onboardingVC.skipHandler = ^{
        if (![LBXControllerServices isLoggedIn]) {
            SIAlertView *alert = [[SIAlertView alloc] initWithTitle:@"Continue Without An Account?" andMessage:@"Accounts are required to create a Pull List and track comics."];
            [alert addButtonWithTitle:@"Sign Up"
                                 type:SIAlertViewButtonTypeCancel
                              handler:^(SIAlertView *alert) {
                                  LBXSignupViewController *signupController = [LBXSignupViewController new];
                                  UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:signupController];
                                  [self.window.rootViewController presentViewController:navigationController animated:YES completion:nil];
                              }];
            [alert addButtonWithTitle:@"Continue"
                                     type:SIAlertViewButtonTypeDefault
                                  handler:^(SIAlertView *alert) {
                                      [self handleOnboardingCompletion];
                                      SIAlertView *alert2 = [[SIAlertView alloc] initWithTitle:@"Enjoy Longboxed!" andMessage:@"If you change your mind, just tap the gear in the top left corner to sign up for an account."];
                                      [alert2 addButtonWithTitle:@"OK"
                                                           type:SIAlertViewButtonTypeCancel
                                                        handler:nil];
                                      alert2.titleFont = [UIFont alertViewTitleFont];
                                      alert2.messageFont = [UIFont alertViewMessageFont];
                                      alert2.buttonFont = [UIFont alertViewButtonFont];
                                      alert2.transitionStyle = SIAlertViewTransitionStyleDropDown;
                                      [alert2 show];
                                  }];
            alert.titleFont = [UIFont alertViewTitleFont];
            alert.messageFont = [UIFont alertViewMessageFontSmall];
            alert.buttonFont = [UIFont alertViewButtonFont];
            alert.transitionStyle = SIAlertViewTransitionStyleDropDown;
            [alert show];
        }
        else {
            [self handleOnboardingCompletion];
        }
    };
    
    return onboardingVC;
}

- (OnboardingViewController *)generateThirdDemoVC {
    OnboardingContentViewController *firstPage = [[OnboardingContentViewController alloc] initWithTitle:@"It's one small step for a man..." body:@"The first man on the moon, Buzz Aldrin, only had one photo taken of him while on the lunar surface due to an unexpected call from Dick Nixon." image:[UIImage imageNamed:@"space1"] buttonText:nil action:nil];
    firstPage.bodyFontSize = 25;
    
    OnboardingContentViewController *secondPage = [[OnboardingContentViewController alloc] initWithTitle:@"The Drake Equation" body:@"In 1961, Frank Drake proposed a probabilistic formula to help estimate the number of potential active and radio-capable extraterrestrial civilizations in the Milky Way Galaxy." image:[UIImage imageNamed:@"space2"] buttonText:nil action:nil];
    secondPage.bodyFontSize = 24;
    
    OnboardingContentViewController *thirdPage = [[OnboardingContentViewController alloc] initWithTitle:@"Cold Welding" body:@"Two pieces of metal without any coating on them will form into one piece in the vacuum of space." image:[UIImage imageNamed:@"space3"] buttonText:nil action:nil];
    
    OnboardingContentViewController *fourthPage = [[OnboardingContentViewController alloc] initWithTitle:@"Goodnight Moon" body:@"Every year the moon moves about 3.8cm further away from the Earth." image:[UIImage imageNamed:@"space4"] buttonText:@"See Ya Later!" action:nil];
    
    OnboardingViewController *onboardingVC = [[OnboardingViewController alloc] initWithBackgroundImage:[UIImage imageNamed:@"milky_way.jpg"] contents:@[firstPage, secondPage, thirdPage, fourthPage]];
    onboardingVC.shouldMaskBackground = NO;
    onboardingVC.shouldBlurBackground = YES;
    onboardingVC.fadePageControlOnLastPage = YES;
    return onboardingVC;
}

- (OnboardingViewController *)generateFourthDemoVC {
    OnboardingContentViewController *firstPage = [[OnboardingContentViewController alloc] initWithTitle:@"Organize" body:@"Everything has its place. We take care of the housekeeping for you. " image:[UIImage imageNamed:@"layers"] buttonText:nil action:nil];
    
    OnboardingContentViewController *secondPage = [[OnboardingContentViewController alloc] initWithTitle:@"Relax" body:@"Grab a nice beverage, sit back, and enjoy the experience." image:[UIImage imageNamed:@"coffee"] buttonText:nil action:nil];
    
    OnboardingContentViewController *thirdPage = [[OnboardingContentViewController alloc] initWithTitle:@"Rock Out" body:@"Import your favorite tunes and jam out while you browse." image:[UIImage imageNamed:@"headphones"] buttonText:nil action:nil];
    
    OnboardingContentViewController *fourthPage = [[OnboardingContentViewController alloc] initWithTitle:@"Experiment" body:@"Try new things, explore different combinations, and see what you come up with!" image:[UIImage imageNamed:@"testtube"] buttonText:@"Let's Get Started" action:nil];
    
    OnboardingViewController *onboardingVC = [[OnboardingViewController alloc] initWithBackgroundImage:[UIImage imageNamed:@"purple"] contents:@[firstPage, secondPage, thirdPage, fourthPage]];
    onboardingVC.shouldMaskBackground = NO;
    onboardingVC.iconSize = 160;
    onboardingVC.fontName = @"HelveticaNeue-Thin";
    return onboardingVC;
}

- (OnboardingViewController *)generateFifthDemoVC {
    OnboardingContentViewController *firstPage = [[OnboardingContentViewController alloc] initWithTitle:@"\"If you can't explain it simply, you don't know it well enough.\"" body:@"                 - Einsten" image:[UIImage imageNamed:@""] buttonText:nil action:nil];
    
    OnboardingContentViewController *secondPage = [[OnboardingContentViewController alloc] initWithTitle:@"\"If you wish to make an apple pie from scratch, you must first invent the universe.\"" body:@"                 - Sagan" image:nil buttonText:nil action:nil];
    secondPage.topPadding = 0;
    
    OnboardingContentViewController *thirdPage = [[OnboardingContentViewController alloc] initWithTitle:@"\"That which can be asserted without evidence, can be dismissed without evidence.\"" body:@"                 - Hitchens" image:nil buttonText:nil action:nil];
    thirdPage.titleFontSize = 33;
    thirdPage.bodyFontSize = 25;
    
    OnboardingContentViewController *fourthPage = [[OnboardingContentViewController alloc] initWithTitle:@"\"Scientists have become the bearers of the torch of discovery in our quest for knowledge.\"" body:@"                 - Hawking" image:nil buttonText:@"Start" action:nil];
    fourthPage.titleFontSize = 28;
    fourthPage.bodyFontSize = 24;
    
    OnboardingViewController *onboardingVC = [[OnboardingViewController alloc] initWithBackgroundImage:[UIImage imageNamed:@"yellowbg"] contents:@[firstPage, secondPage, thirdPage, fourthPage]];
    onboardingVC.shouldMaskBackground = NO;
    onboardingVC.titleTextColor = [UIColor colorWithRed:57/255.0 green:57/255.0 blue:57/255.0 alpha:1.0];;
    onboardingVC.bodyTextColor = [UIColor colorWithRed:244/255.0 green:64/255.0 blue:40/255.0 alpha:1.0];
    onboardingVC.fontName = @"HelveticaNeue-Italic";
    return onboardingVC;
}


@end
