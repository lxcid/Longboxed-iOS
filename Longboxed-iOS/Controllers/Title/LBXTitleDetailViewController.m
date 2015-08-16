//
//  LBXTitleViewController.m
//  Longboxed-iOS
//
//  Created by johnrhickey on 8/10/14.
//  Copyright (c) 2014 Longboxed. All rights reserved.
//
#import "LBXClient.h"
#import "LBXPullListTableViewCell.h"
#import "LBXPullListTitle.h"
#import "LBXTitle.h"
#import "LBXBundle.h"
#import "LBXTitleDetailView.h"
#import "LBXTitleDetailViewController.h"
#import "LBXControllerServices.h"
#import "LBXIssueDetailViewController.h"
#import "LBXIssueScrollViewController.h"
#import "LBXPublisherDetailViewController.h"
#import "LBXLogging.h"

#import "PaintCodeImages.h"
#import "JGActionSheet.h"
#import "SVProgressHUD.h"

#import "UIFont+LBXCustomFonts.h"
#import "NSString+LBXStringUtilities.h"
#import "UIImage+LBXCreateImage.h"
#import "NSArray+LBXArrayUtilities.h"
#import "UIColor+LBXCustomColors.h"

#import <JTSImageViewController.h>
#import <QuartzCore/QuartzCore.h>
#import <JRHUtilities/NSDate+DateUtilities.h>
#import <NSString+HTML.h>

@interface LBXTitleDetailViewController () <UIScrollViewDelegate, JTSImageViewControllerInteractionsDelegate, JTSImageViewControllerDismissalDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, copy) LBXTitle *detailTitle;
@property (nonatomic, copy) LBXClient *client;
@property (nonatomic, copy) LBXTitleDetailView *detailView;
@property (nonatomic, copy) UILabel *navTitleView;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation LBXTitleDetailViewController

static const NSUInteger ISSUE_TABLE_HEIGHT = 88;
static BOOL addToPullList = NO;
BOOL endOfIssues;
BOOL saveSheetVisible;
int page;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Calls perferredStatusBarStyle
    [self setNeedsStatusBarAppearanceUpdate];
    
    UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"clear"] style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.rightBarButtonItem = actionButton;
    
    endOfIssues = NO;
    
    _client = [LBXClient new];
    
    page = 1;
    
    // Dynamically set the detail view size and following table view content offset
    [self setDetailView];
    [self setPullListButton];
    [self setFrameRect];
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"setFrameAgain"
     object:self userInfo:nil];
    _detailView.frame = self.frameRect;
    _detailView.bounds = CGRectMake(self.frameRect.origin.x, self.frameRect.origin.y - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height, self.frameRect.size.width, self.frameRect.size.height);
    [self setOverView:_detailView];
    
    [self fetchTitle];
    [self fetchPullList];
    [self fetchAllIssuesWithPage:@1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(setForegroundImageView)
                                                 name:@"setTitleDetailForegroundImage"
                                               object:nil];
    
    
    UIImage *backgroundImageToBlur = [UIImage new];
    if ([UIImagePNGRepresentation(_latestIssueImage) isEqual:UIImagePNGRepresentation([UIImage defaultCoverImage])]) {
        backgroundImageToBlur = [UIImage imageNamed:@"black"];
        _latestIssueImage = [UIImage defaultCoverImageWithWhiteBackground];
        _detailView.latestIssueImageView.image = _latestIssueImage;
    }
    else {
        backgroundImageToBlur = _detailView.latestIssueImageView.image;
    }
    // Adjustment for images with a height that is less than _detailView.latestIssueImageView
    [self setCustomBlurredBackgroundImageWithImage:backgroundImageToBlur];
    
    [LBXControllerServices setupTransparentNavigationBarForViewController:self];
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        [LBXLogging logMessage:[NSString stringWithFormat:@"Unresolved error in title detail view controller %@, %@ \n %@", error, [error userInfo], _detailTitle]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [LBXControllerServices setViewWillAppearClearNavigationController:self];
    
    self.tableView.rowHeight = ISSUE_TABLE_HEIGHT;
    
    [self setNavBarAlpha:@0];
    
    // Keep the section header on the top
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:tableSelection animated:YES];
    
    // Fix for mainimageview frame getting screwed up when you drill deep and the pop back up to a title view
    [self.mainImageView setFrame:CGRectMake(0, 0, self.overView.frame.size.width, self.overView.frame.size.height + self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height)];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [LBXControllerServices setNumberOfLinesWithLabel:_detailView.titleLabel string:_detailTitle.name font:[UIFont titleDetailTitleFont]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [LBXLogging logMessage:[NSString stringWithFormat:@"LBXTitle:\n%@\ndid appear", _detailTitle]];
    
    [LBXControllerServices setViewDidAppearClearNavigationController:self];
    
    _navTitleView = [UILabel new];
    _navTitleView.frame = CGRectMake(self.view.frame.origin.x, [UIScreen mainScreen].bounds.origin.y + [UIApplication sharedApplication].statusBarFrame.size.height, self.navigationController.navigationBar.frame.size.width, self.navigationController.navigationBar.frame.size.height);
    _navTitleView.text = _detailTitle.name;
    _navTitleView.textColor = [UIColor whiteColor];
    _navTitleView.font = [UIFont navTitleFont];
    _navTitleView.textAlignment = NSTextAlignmentCenter;
    _navTitleView.alpha = 0.0;
    [self.view addSubview:_navTitleView];
    
    if (self.tableView.contentOffset.y > 0) {
        // Set the title alpha properly when returning from the issue view
        [self setNavBarAlpha:@(1 - self.overView.alpha)];
    }
    else {
        [self setNavBarAlpha:@0];
    }
    
    [self.tableView flashScrollIndicators];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [LBXControllerServices setViewWillDisappearClearNavigationController:self];
    self.navigationController.navigationBar.topItem.title = @" ";
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"setTitleDetailForegroundImage" object:nil];
}

- (void)setDetailView
{
    _detailView = [LBXTitleDetailView new];
    _detailView.titleLabel.font = [UIFont titleDetailTitleFont];
    _detailView.publisherButton.titleLabel.font = [UIFont titleDetailPublisherFont];
    
    [self updateDetailView];
    
    _detailView.latestIssueImageView.image = _latestIssueImage;
    _detailView.latestIssueImageView.contentMode = UIViewContentModeScaleAspectFit;
    if (_latestIssueImage.size.height < _detailView.latestIssueImageView.frame.size.height) {
        _detailView.latestIssueImageView.contentMode = UIViewContentModeScaleAspectFill;
        _detailView.latestIssueImageView.clipsToBounds = YES;
    }
}

- (void)setForegroundImageView
{
    [UIView transitionWithView:_detailView.latestIssueImageView
                      duration:0.3f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        _detailView.latestIssueImageView.image = self.foregroundImage;
                    } completion:nil];
    _detailView.latestIssueImageView.contentMode = UIViewContentModeScaleAspectFit;
    [_detailView.latestIssueImageView sizeToFit];
    [_detailView setNeedsLayout];
}

- (void)setFrameRect
{
    CGFloat titleHeight = [_detailTitle.name boundingRectWithSize:_detailView.titleLabel.frame.size
                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                       attributes:@{NSFontAttributeName:_detailView.titleLabel.font}
                                                          context:nil].size.height;
    
    CGFloat publisherHeight = [_detailTitle.publisher.name boundingRectWithSize:_detailView.publisherButton.frame.size
                                                                        options:NSStringDrawingUsesLineFragmentOrigin
                                                                     attributes:@{NSFontAttributeName:_detailView.publisherButton.titleLabel.font}
                                                                        context:nil].size.height;
    
    CGFloat addToPullListHeight = ([LBXControllerServices isLoggedIn]) ? _detailView.addToPullListButton.frame.size.height : 0.0;
    
    CGFloat imageHeight = ([LBXControllerServices isLoggedIn]) ? _detailView.latestIssueImageView.frame.size.height : _detailView.latestIssueImageView.frame.size.height - 52;
    
    self.frameRect = CGRectMake(0, self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height, self.view.frame.size.width, MAX(titleHeight + publisherHeight + addToPullListHeight + self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height, imageHeight));
}

- (void)updateDetailView
{
    _detailView.titleLabel.text = _detailTitle.name;
    [LBXControllerServices setNumberOfLinesWithLabel:_detailView.titleLabel string:_detailTitle.name font:[UIFont titleDetailTitleFont]];
    
    // When loading the title info
    if (_detailTitle.publisher.name == nil) {
        [_detailView.publisherButton setTitle:@"Loading..." forState:UIControlStateNormal];
        _detailView.issuesAndSubscribersLabel.text = @"";
        [_detailView.publisherButton setTitle:@"Loading..." forState:UIControlStateNormal];
        _detailView.publisherButton.userInteractionEnabled = NO;
    }
    else {
        _detailView.publisherButton.userInteractionEnabled = YES;
        [_detailView.publisherButton setTitle:[_detailTitle.publisher.name uppercaseString] forState:UIControlStateNormal];
        
        NSString *issuesString;
        if ([_detailTitle.issueCount isEqualToNumber:@1]) {
            issuesString = [NSString stringWithFormat:@"%@ Issue", _detailTitle.issueCount];
        }
        else {
            issuesString = [NSString stringWithFormat:@"%@ Issues", _detailTitle.issueCount];
        }
        
        NSString *subscribersString = [NSString getSubtitleStringWithTitle:_detailTitle uppercase:YES];
        
        _detailView.issuesAndSubscribersLabel.text = [NSString stringWithFormat:@"%@  •  %@", [issuesString uppercaseString], [subscribersString uppercaseString]];
        _detailView.issuesAndSubscribersLabel.font = [UIFont titleDetailSubscribersAndIssuesFont];
    }
    
    // Move the arrow so it is on the right side of the publisher text
    _detailView.publisherButton.titleEdgeInsets = UIEdgeInsetsMake(0, -_detailView.publisherButton.imageView.frame.size.width, 0, _detailView.publisherButton.imageView.frame.size.width);
    _detailView.publisherButton.imageEdgeInsets = UIEdgeInsetsMake(0, _detailView.publisherButton.titleLabel.frame.size.width + 8, 0, -_detailView.publisherButton.titleLabel.frame.size.width);
    _detailView.publisherButton.tag = 1;
    [_detailView.publisherButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _detailView.latestIssueLabel.font = [UIFont titleDetailLatestIssueFont];
    if (_detailTitle.latestIssue != nil) {
        
        NSString *timeSinceString = [NSString timeStringSinceLastIssueForTitle:_detailTitle];
        
        NSString *subtitleString = [NSString stringWithFormat:@"Latest issue released %@", timeSinceString];
        if ([timeSinceString hasPrefix:@"in"] || [timeSinceString containsString:@"tomorrow"]) {
            subtitleString = [NSString stringWithFormat:@"Next issue will be released %@", timeSinceString];
        }
        _detailView.latestIssueLabel.text = subtitleString;
    }
    else if (!_fetchedResultsController.fetchedObjects.count) {
        _detailView.latestIssueLabel.text = @"No issues released";
    }
    else {
        _detailView.latestIssueLabel.text = @"";
    }
    
    _detailView.imageViewButton.tag = 2;
    [_detailView.imageViewButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view setNeedsDisplay];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark JTSImageViewControllerInteractionsDelegate methods

- (void)imageViewerDidLongPress:(JTSImageViewController *)imageViewer atRect:(CGRect)rect
{
    if (!saveSheetVisible) {
        JGActionSheetSection *section1 = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"Save Image", @"Copy Image"] buttonStyle:JGActionSheetButtonStyleDefault];
        JGActionSheetSection *cancelSection = [JGActionSheetSection sectionWithTitle:nil message:nil buttonTitles:@[@"Cancel"] buttonStyle:JGActionSheetButtonStyleCancel];
        
        NSArray *sections = @[section1, cancelSection];
        
        JGActionSheet *sheet = [JGActionSheet actionSheetWithSections:sections];
        
        [sheet setButtonPressedBlock:^(JGActionSheet *sheet, NSIndexPath *indexPath) {
            switch (indexPath.section) {
                case 0:
                    switch (indexPath.row) {
                        case 0:
                        {
                            UIImageWriteToSavedPhotosAlbum(_detailView.latestIssueImageView.image, nil, nil, nil);
                            [SVProgressHUD showSuccessWithStatus:@"Saved to Photos" maskType:SVProgressHUDMaskTypeBlack];
                            break;
                        }
                        case 1:
                        {
                            [LBXControllerServices copyImageToPasteboard:_detailView.latestIssueImageView.image];
                            break;
                        }
                        default:
                            break;
                    }
                    break;
                default:
                    break;
            }
            [sheet dismissAnimated:YES];
            saveSheetVisible = NO;
        }];
        saveSheetVisible = YES;
        [sheet showInView:imageViewer.view animated:YES];
    }
}

#pragma mark JTSImageViewControllerDismissalDelegate methods

// Sometimes the status bar will go to black text. This changes it white
- (void)imageViewerDidDismiss:(JTSImageViewController *)imageViewer
{
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (BOOL)imageViewerShouldTemporarilyIgnoreTouches:(JTSImageViewController *)imageViewer
{
    if (saveSheetVisible) return YES;
    return NO;
}

#pragma mark - Private methods

- (void)setPullListButton
{
    _detailView.addToPullListButton.tag = 0;
    [_detailView.addToPullListButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    if (self.detailTitle.isInPullList) {
        [_detailView.addToPullListButton setTitle:@"     REMOVE FROM PULL LIST     " forState:UIControlStateNormal];
        _detailView.addToPullListButton.layer.borderColor = [[UIColor whiteColor] CGColor];
        addToPullList = YES;
    }
    else {
        [_detailView.addToPullListButton setTitle:@"     ADD TO PULL LIST     " forState:UIControlStateNormal];
        _detailView.addToPullListButton.layer.borderColor = [[UIColor whiteColor] CGColor];
        addToPullList = NO;
    }
    _detailView.addToPullListButton.titleLabel.font = [UIFont titleDetailAddToPullListFont];
    _detailView.addToPullListButton.layer.borderWidth = 1.0f;
    _detailView.addToPullListButton.layer.cornerRadius = 19.0f;
    [_detailView.addToPullListButton setNeedsLayout];
}

- (IBAction)onClick:(id)sender
{
    UIButton *button = (UIButton *)sender;
    switch ([button tag]) {
        case 0: // Add title to pull list
        {
            if (addToPullList == YES) {
                [self deleteTitle:_detailTitle];
                addToPullList = NO;
                [_detailView.addToPullListButton setTitle:@"     ADD TO PULL LIST     " forState:UIControlStateNormal];
            }
            else if (addToPullList == NO) {
                addToPullList = YES;
                [self addTitle:_detailTitle];
                [_detailView.addToPullListButton setTitle:@"     REMOVE FROM PULL LIST     " forState:UIControlStateNormal];
            }
            break;
        }
        case 1:
        {
            LBXPublisherDetailViewController *publisherViewController = [LBXPublisherDetailViewController new];
            
            publisherViewController.publisherID = _detailTitle.publisher.publisherID;
            
            [self.navigationController pushViewController:publisherViewController animated:YES];
            break;
        }
        case 2:
        {
            // Create image info
            JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
            imageInfo.image = _detailView.latestIssueImageView.image;
            imageInfo.referenceRect = _detailView.latestIssueImageView.frame;
            imageInfo.referenceView = _detailView.latestIssueImageView.superview;
            
            // Setup view controller
            JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                                   initWithImageInfo:imageInfo
                                                   mode:JTSImageViewControllerMode_Image
                                                   backgroundStyle:JTSImageViewControllerBackgroundOption_Blurred];
            imageViewer.interactionsDelegate = self;
            imageViewer.dismissalDelegate = self;
            
            // Present the view controller.
            [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
            
            // Make the status bar white again for when dismissing the image view
            self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
            
            break;
        }
    }
}

- (void)setDetailTitleWithID:(NSNumber *)ID
{
    _detailTitle = [LBXTitle MR_findFirstByAttribute:@"titleID" withValue:ID inContext:[NSManagedObjectContext MR_defaultContext]];
}

- (void)fetchPullList
{
    // Fetch pull list titles
    [_client fetchPullListWithCompletion:^(NSArray *pullListArray, RKObjectRequestOperation *response, NSError *error) {
        
        if (!error) {
            [self setPullListButton];
        }
        [self.view setNeedsDisplay];
    }];
}

- (void)fetchTitle
{
    [_client fetchTitle:_titleID withCompletion:^(LBXTitle *title, RKObjectRequestOperation *response, NSError *error) {
        
        if (!error) {
            _detailTitle = title;
            [self updateDetailView];
        }
        [self.view setNeedsDisplay];
    }];
}

- (void)fetchAllIssuesWithPage:(NSNumber *)page
{
    if ([page intValue] > 1 && !endOfIssues) {
        // Add a footer loading spinner
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner startAnimating];
        spinner.frame = CGRectMake(0, 0, 320, 44);
        self.tableView.tableFooterView = spinner;
    }
    
    // Fetch pull list titles
    [_client fetchIssuesForTitle:_titleID page:page withCompletion:^(NSArray *pullListArray, RKObjectRequestOperation *response, NSError *error) {
        if (!error && pullListArray.count == 0) {
            endOfIssues = YES;
            self.tableView.tableFooterView = nil;
        }
    }];
}

- (void)setNavBarAlpha:(NSNumber *)alpha
{
    _navTitleView.alpha = [alpha doubleValue];
}

- (void)addTitle:(LBXTitle *)title
{
    LBXTitle *saveTitle = [LBXTitle MR_createEntity];
    saveTitle = title;
    LBXPullListTitle *pullListTitle = [LBXPullListTitle MR_createEntity];
    pullListTitle.name = title.name;
    pullListTitle.subscribers = title.subscribers;
    pullListTitle.publisher = title.publisher;
    pullListTitle.titleID = title.titleID;
    pullListTitle.issueCount = title.issueCount;
    pullListTitle.latestIssue = title.latestIssue;
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    [self setPullListButton];
     __block typeof(self) weakself = self;
    [self.client addTitleToPullList:title.titleID withCompletion:^(NSArray *pullListArray, AFHTTPRequestOperation *response, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself setPullListButton];
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"reloadDashboard"
                 object:weakself];
            });
        }
    }];
}

- (void)deleteTitle:(LBXTitle *)title
{
    // Fetch pull list titles
    __block typeof(self) weakself = self;
    [self.client removeTitleFromPullList:title.titleID withCompletion:^(NSArray *pullListArray, AFHTTPRequestOperation *response, NSError *error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakself setPullListButton];
                [[NSNotificationCenter defaultCenter]
                 postNotificationName:@"reloadDashboard"
                 object:weakself];
            });
        }
    }];
}

#pragma mark - Setter overrides

- (void)setTitleID:(NSNumber *)titleID
{
    _titleID = titleID;
    [self setDetailTitleWithID:titleID];
}

#pragma mark - UITableView Delegate & Datasource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0)
        return [super tableView:tableView viewForHeaderInSection:section];
    
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:0.8];
    
    // Text Color and font
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setTextColor:[UIColor blackColor]];
    [[UILabel appearanceWhenContainedIn:[UITableViewHeaderFooterView class], nil] setFont:[UIFont titleDetailSubscribersAndIssuesFont]];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 1)
        return @"Issues";
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if(section == 0)
        return [super tableView:tableView heightForHeaderInSection:section];
    
    if(section == 1)
        return 18.0;
    
    return 0.0;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSInteger mySections = 1;
    
    return mySections + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section != 1) {
        return 0;
    }
    
    return _fetchedResultsController.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"PullListCell";
    
    LBXPullListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        // Custom cell as explained here: https://medium.com/p/9bee5824e722
        [tableView registerNib:[UINib nibWithNibName:@"LBXPullListTableViewCell" bundle:nil] forCellReuseIdentifier:@"PullListCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"PullListCell"];
        
        // Remove inset of iOS 7 separators.
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
            cell.separatorInset = UIEdgeInsetsZero;
        }
        
    }
    
    if ([indexPath row] == _fetchedResultsController.fetchedObjects.count - 1 && !endOfIssues) {
        page += 1;
        [self fetchAllIssuesWithPage:[NSNumber numberWithInt:page]];
    }
    
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(LBXPullListTableViewCell*)cell atIndexPath:(NSIndexPath*)indexPath {

    // Configure the cell...
    if (_fetchedResultsController.fetchedObjects.count <= indexPath.row) {
        return;
    }
    
    LBXIssue *issue = [_fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
    
    cell.titleLabel.font = [UIFont pullListTitleFont];
    cell.titleLabel.text = issue.completeTitle;
    cell.titleLabel.numberOfLines = 2;
    cell.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    cell.subtitleLabel.font = [UIFont pullListSubtitleFont];
    cell.subtitleLabel.textColor = [UIColor grayColor];
    cell.subtitleLabel.numberOfLines = 2;
    
    cell.latestIssueImageView.image = nil;
    
    [LBXControllerServices setTitleCell:cell withIssue:issue];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    
    // Setting the background color of the cell.
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y > 0) {
        [self setNavBarAlpha:@(1 - self.overView.alpha)];
    }
    else {
        [self setNavBarAlpha:@0];
    }
    
    return [super scrollViewDidScroll:scrollView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Disselect and return immediately if selecting an empty cell
    // i.e., one below the last issue
    if (_fetchedResultsController.fetchedObjects.count < indexPath.row+1) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        return;
    }
    
    LBXIssue *issue = [_fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
    [LBXLogging logMessage:[NSString stringWithFormat:@"Selected issue %@", issue]];
    LBXPullListTableViewCell *cell = (LBXPullListTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    // Set up the scroll view controller containment if there are alternate issues
    if (issue.alternates.count) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat: @"(title == %@) AND (issueNumber == %@)", issue.title, issue.issueNumber];
        NSArray *issuesArray = [LBXIssue MR_findAllSortedBy:@"completeTitle" ascending:YES withPredicate:predicate];
        LBXIssueScrollViewController *scrollViewController = [[LBXIssueScrollViewController alloc] initWithIssues:issuesArray andImage:cell.latestIssueImageView.image];
        [self.navigationController pushViewController:scrollViewController animated:YES];
    }
    else {
        LBXIssueDetailViewController *titleViewController = [[LBXIssueDetailViewController alloc] initWithMainImage:cell.latestIssueImageView.image];
        titleViewController.issue = issue;
        [self.navigationController pushViewController:titleViewController animated:YES];
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


// Swipe to share
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *shareAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Share" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath){
        // maybe show an action sheet with more options
        LBXIssue *issue =  [_fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
        NSString *infoString = [issue.completeTitle stringByDecodingHTMLEntities];
        NSString *urlString = [NSString stringWithFormat:@"%@%@", @"https://longboxed.com/issue/", issue.diamondID];
        NSString *viaString = [NSString stringWithFormat:@"\nvia @longboxed for iOS"];
        UIImage *coverImage = _detailView.latestIssueImageView.image;
        [LBXControllerServices showShareSheetWithArrayOfInfo:@[infoString, [NSURL URLWithString:urlString], viaString, coverImage]];
        [self.tableView setEditing:NO];
    }];
    shareAction.backgroundColor = [UIColor LBXBlueColor];
    
    return @[shareAction];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Necessary to exist to allow share sheet
}

#pragma mark NSFetchedResultsController Methods

- (NSFetchedResultsController *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat: @"(title == %@) AND (isParent == 1)", _detailTitle];
    _fetchedResultsController = [LBXIssue MR_fetchAllSortedBy:@"releaseDate" ascending:NO withPredicate:predicate groupBy:nil delegate:self];
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    // Section 0 is not used for MGSpotyViewController
    newIndexPath = [NSIndexPath indexPathForRow:newIndexPath.row inSection:1];
    indexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:1];
    UITableView *tableView = self.tableView;
        switch(type) {
                
            case NSFetchedResultsChangeInsert:
                [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeDelete:
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
                
            case NSFetchedResultsChangeUpdate:
                [self configureCell:(LBXPullListTableViewCell *)[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
                break;
                
            case NSFetchedResultsChangeMove:
                [tableView deleteRowsAtIndexPaths:[NSArray
                                                   arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                [tableView insertRowsAtIndexPaths:[NSArray
                                                   arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                break;
        }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    // Section 0 is not used for MGSpotyViewController
    sectionIndex = 1;
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeMove:
            break;
        case NSFetchedResultsChangeUpdate:
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}

@end
