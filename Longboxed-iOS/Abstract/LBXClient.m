//
//  LBXClient.m
//  Longboxed-iOS
//
//  Created by johnrhickey on 6/29/14.
//  Copyright (c) 2014 Longboxed. All rights reserved.
//

#import <RestKit/CoreData.h>
#import <UICKeyChainStore.h>

#import "LBXClient.h"
#import "LBXMap.h"
#import "LBXDescriptors.h"
#import "LBXEndpoints.h"
#import "LBXPullListTitle.h"
#import "LBXBundle.h"

#import "NSData+Base64.h"
#import "NSString+URLQuery.h"
#import "NSString+RKAdditions.h"
#import "NSDictionary+RKAdditions.h"
#import "NSArray+LBXArrayUtilities.h"

@interface LBXClient()

@property (nonatomic) NSURLSession *session;

@end

@implementation LBXClient

+ (void)setAuth
{
    UICKeyChainStore *store = [UICKeyChainStore keyChainStore];
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", store[@"username"], store[@"password"]];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodingWithLineLength:80]];
    [[[RKObjectManager sharedManager] HTTPClient] setDefaultHeader:@"Authorization" value:authValue];
}

- (void)GETWithRouteName:(NSString *)routeName
        HTTPHeaderParams:(NSString *)HTTPHeaderParams
         queryParameters:(NSDictionary *)parameters
             credentials:(BOOL)credentials
              completion:(void (^)(RKMappingResult*, RKObjectRequestOperation*, NSError*))completion
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    if (credentials) {
        // Set the shared manager auth
        [LBXClient setAuth];
    }
    
    NSDictionary *endpointDict = [LBXEndpoints endpoints];
    
    NSString *path = endpointDict[routeName];
    if (HTTPHeaderParams) {
        path = [endpointDict[routeName] interpolateWithObject:HTTPHeaderParams];
    }
    
    [RKObjectManager.sharedManager getObjectsAtPath:path parameters:parameters success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult)
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (completion) {
            completion(mappingResult, operation, nil);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (completion) {
            completion(nil, operation, error);
        }
    }];
}

// Using AFNetworking for the POST and DELETE requests
// instead of over-abstracting things with RESTKIT
- (void)POSTWithRouteName:(NSString *)routeName
         HTTPHeaderParams:(NSDictionary *)HTTPHeaderParams
           queryParameters:(NSDictionary *)parameters
              credentials:(BOOL)credentials
               completion:(void (^)(NSDictionary*, AFHTTPRequestOperation*, NSError*))completion
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    // Set up the URL route with the parameter suffix
    NSDictionary *endpointDict = [LBXEndpoints endpoints];
    
    AFHTTPClient *client = [self setupAFNetworkingRouter];
    
    NSString *postPath = endpointDict[routeName];
    
    // Auth
    if (credentials) {
        UICKeyChainStore *store = [UICKeyChainStore keyChainStore];
        [client setAuthorizationHeaderWithUsername:store[@"username"] password:store[@"password"]];
        postPath = [[NSString addQueryStringToUrlString:endpointDict[routeName]
                                                   withDictionary:HTTPHeaderParams] stringByReplacingOccurrencesOfString:@":userID" withString:store[@"id"]];
    }
 
    [client postPath:postPath
          parameters:parameters
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                 NSDictionary* jsonFromData = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                 if (completion) {
                     completion(jsonFromData, operation, nil);
                 }
                 
             } failure:^( AFHTTPRequestOperation *operation, NSError *error) {
                 completion(nil, operation, error);
             }];

}

// Using AFNetworking for the POST and DELETE requests
// instead of over-abstracting things with RESTKIT
- (void)DELETEWithRouteName:(NSString *)routeName
           HTTPHeaderParams:(NSDictionary *)HTTPHeaderParams
            queryParameters:(NSDictionary *)parameters
                credentials:(BOOL)credentials
                 completion:(void (^)(NSDictionary*, AFHTTPRequestOperation*, NSError*))completion
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    // Set up the URL route with the parameter suffix
    NSDictionary *endpointDict = [LBXEndpoints endpoints];
    
    AFHTTPClient *client = [self setupAFNetworkingRouter];
    
    // Auth
    UICKeyChainStore *store = [UICKeyChainStore keyChainStore];
    [client setAuthorizationHeaderWithUsername:store[@"username"] password:store[@"password"]];
    
    NSString *deletePath = endpointDict[routeName];
    if (HTTPHeaderParams) {
        deletePath = [[NSString addQueryStringToUrlString:endpointDict[routeName]
                                           withDictionary:HTTPHeaderParams] stringByReplacingOccurrencesOfString:@":userID"
                                                                                                withString:store[@"id"]];
    }
    [client deletePath:deletePath
          parameters:parameters
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
                 NSDictionary* jsonFromData = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                 
                 if (completion) {
                     completion(jsonFromData, operation, nil);
                 }
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 if (completion) {
                     completion(nil, operation, error);
                 }
             }];
    
}

- (AFHTTPClient *)setupAFNetworkingRouter
{
    // Prepare the request
    AFHTTPClient *client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:[UICKeyChainStore stringForKey:@"baseURLString"]]];
    client.parameterEncoding = AFJSONParameterEncoding;
    
    // For the self signed production SSL cert
    if ([[UICKeyChainStore stringForKey:@"baseURLString"] isEqualToString:[[LBXEndpoints stagingURL] absoluteString]]) {
        client.allowsInvalidSSLCertificate = YES;
    }
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    
    return client;
}

// Issues
- (void)fetchIssuesCollectionWithDate:(NSDate *)date page:(NSNumber*)page completion:(void (^)(NSArray *, RKObjectRequestOperation *, NSError *))completion
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    // For debugging
    NSDictionary *parameters = @{@"date" : [formatter stringFromDate:date], @"page" : [NSString stringWithFormat:@"%d", [page intValue]]};
    [self GETWithRouteName:@"Issues Collection" HTTPHeaderParams:nil queryParameters:parameters credentials:NO completion:^(RKMappingResult *mappingResult, RKObjectRequestOperation *response, NSError *error) {
        
        if (!error) {
            for (LBXIssue *issue in mappingResult.array) {
                [self saveAlternateIssuesWithIssue:issue];
            }
        }
        
        completion(mappingResult.array, response, error);
    }];
}

- (void)fetchThisWeeksComicsWithPage:(NSNumber *)page completion:(void (^)(NSArray*, RKObjectRequestOperation *, NSError*))completion {
    
    NSDictionary *objectDictParams;
    if (![page isEqualToNumber:@1]) {
        objectDictParams = @{@"page" : [NSString stringWithFormat:@"%d", [page intValue]]};
    }
    [self GETWithRouteName:@"Issues Collection for Current Week" HTTPHeaderParams:nil queryParameters:objectDictParams credentials:NO completion:^(RKMappingResult *mappingResult, RKObjectRequestOperation *response, NSError *error) {
        
        if (!error) {
            for (LBXIssue *issue in mappingResult.array) {
                [self saveAlternateIssuesWithIssue:issue];
            }
        }
        
        completion(mappingResult.array, response, error);
    }];
}

- (void)fetchNextWeeksComicsWithPage:(NSNumber *)page completion:(void (^)(NSArray*, RKObjectRequestOperation *, NSError*))completion {
    
    NSDictionary *objectDictParams;
    if (![page isEqualToNumber:@1]) {
        objectDictParams = @{@"page" : [NSString stringWithFormat:@"%d", [page intValue]]};
    }
    [self GETWithRouteName:@"Issues Collection for Next Week" HTTPHeaderParams:nil queryParameters:objectDictParams credentials:NO completion:^(RKMappingResult *mappingResult, RKObjectRequestOperation *response, NSError *error) {
        
        if (!error) {
            for (LBXIssue *issue in mappingResult.array) {
                [self saveAlternateIssuesWithIssue:issue];
            }
        }
        
        completion(mappingResult.array, response, error);
    }];
}

- (void)fetchIssue:(NSNumber*)issueID withCompletion:(void (^)(LBXIssue*, RKObjectRequestOperation*, NSError*))completion {

    NSString *params = [NSDictionary dictionaryWithKeysAndObjects:
                        @"issueID", issueID,
                        nil];
    
    [self GETWithRouteName:@"Issue" HTTPHeaderParams:params queryParameters:nil credentials:NO completion:^(RKMappingResult *mappingResult, RKObjectRequestOperation *response, NSError *error) {
        
        if (!error) [self saveAlternateIssuesWithIssue:mappingResult.firstObject];
        
        completion(mappingResult.firstObject, response, error);
    }];
}

- (void)fetchPopularIssuesWithCompletion:(void (^)(NSArray*, RKObjectRequestOperation*, NSError*))completion {
    [self GETWithRouteName:@"Popular Issues for Current Week" HTTPHeaderParams:nil queryParameters:nil credentials:NO completion:^(RKMappingResult *mappingResult, RKObjectRequestOperation *response, NSError *error) {
        
        if (!error) {
            for (LBXIssue *issue in mappingResult.array) {
                [self saveAlternateIssuesWithIssue:issue];
            }
        }
        
        completion(mappingResult.array, response, error);
    }];
}

// Titles
- (void)fetchTitleCollectionWithCompletion:(void (^)(NSArray*, RKObjectRequestOperation*, NSError*))completion {
    [self GETWithRouteName:@"Titles Collection" HTTPHeaderParams:nil queryParameters:nil credentials:NO completion:^(RKMappingResult *mappingResult, RKObjectRequestOperation *response, NSError *error) {
        
        if (!error) {
            for (LBXTitle *title in mappingResult.array) {
                [self saveAlternateIssuesWithIssue:title.latestIssue];
            }
        }
        
        completion(mappingResult.array, response, error);
    }];
}

- (void)fetchTitle:(NSNumber*)titleID withCompletion:(void (^)(LBXTitle*, RKObjectRequestOperation*, NSError*))completion {
    
    NSString *params = [NSDictionary dictionaryWithKeysAndObjects:
                        @"titleID", titleID,
                        nil];
    
    [self GETWithRouteName:@"Title" HTTPHeaderParams:params queryParameters:nil credentials:NO completion:^(RKMappingResult *mappingResult, RKObjectRequestOperation *response, NSError *error) {
        
        if (!error) {
            [self saveAlternateIssuesWithIssue:((LBXTitle *)mappingResult.firstObject).latestIssue];
        }
        
        completion(mappingResult.firstObject, response, error);
    }];
}

- (void)fetchIssuesForTitle:(NSNumber*)titleID page:(NSNumber *)page withCompletion:(void (^)(NSArray*, RKObjectRequestOperation*, NSError*))completion {
    
    NSString *headerParams = [NSDictionary dictionaryWithKeysAndObjects:
                        @"titleID", titleID,
                        nil];
    
    NSDictionary *objectDictParams;
    if (![page isEqualToNumber:@1]) {
        objectDictParams = @{@"page" : [NSString stringWithFormat:@"%d", [page intValue]]};
    }
    
    [self GETWithRouteName:@"Issues for Title" HTTPHeaderParams:headerParams queryParameters:objectDictParams credentials:NO completion:^(RKMappingResult *mappingResult, RKObjectRequestOperation *response, NSError *error) {
        
        if (!error) {
            for (LBXIssue *issue in mappingResult.array) {
                [self saveAlternateIssuesWithIssue:issue];
            }
        }
        
        completion(mappingResult.array, response, error);
    }];
}

- (void)fetchIssuesForTitle:(NSNumber*)titleID page:(NSNumber *)page count:(NSNumber *)count withCompletion:(void (^)(NSArray*, RKObjectRequestOperation*, NSError*))completion {
    
    NSString *headerParams = [NSDictionary dictionaryWithKeysAndObjects:
                        @"titleID", titleID,
                        nil];
    
    NSDictionary *objectDictParams;
    if (![page isEqualToNumber:@1]) {
        objectDictParams = @{@"page" : [NSString stringWithFormat:@"%d", [page intValue]],
                             @"count" : [NSString stringWithFormat:@"%d", [count intValue]]};
    }
    
    [self GETWithRouteName:@"Issues for Title" HTTPHeaderParams:headerParams queryParameters:objectDictParams credentials:NO completion:^(RKMappingResult *mappingResult, RKObjectRequestOperation *response, NSError *error) {
        
        if (!error) {
            for (LBXIssue *issue in mappingResult.array) {
                [self saveAlternateIssuesWithIssue:issue];
            }
        }
        
        completion(mappingResult.array, response, error);
    }];
}

- (void)fetchAutocompleteForTitle:(NSString*)title withCompletion:(void (^)(NSArray*, RKObjectRequestOperation*, NSError*))completion {

    [self GETWithRouteName:@"Autocomplete for Title" HTTPHeaderParams:nil queryParameters:@{@"query": title} credentials:NO completion:^(RKMappingResult *mappingResult, RKObjectRequestOperation *response, NSError *error) {
        
        if (!error) {
            for (LBXTitle *title in mappingResult.array) {
                [self saveAlternateIssuesWithIssue:title.latestIssue];
            }
        }
        
        completion(mappingResult.array, response, error);
    }];
}

// Publishers
- (void)fetchPublishersWithPage:(NSNumber *)page completion:(void (^)(NSArray *, RKObjectRequestOperation*, NSError*))completion {
    
    NSDictionary *objectDictParams;
    if (![page isEqualToNumber:@1]) {
        objectDictParams = @{@"page" : [NSString stringWithFormat:@"%d", [page intValue]]};
    }
    
    [self GETWithRouteName:@"Publisher Collection" HTTPHeaderParams:nil queryParameters:objectDictParams credentials:NO completion:^(RKMappingResult *mappingResult, RKObjectRequestOperation *response, NSError *error) {
        completion(mappingResult.array, response, error);
    }];
}

- (void)fetchPublisher:(NSNumber*)publisherID withCompletion:(void (^)(LBXPublisher*, RKObjectRequestOperation*, NSError*))completion {
    
    NSString *params = [NSDictionary dictionaryWithKeysAndObjects:
                        @"publisherID", publisherID,
                        nil];
    
    [self GETWithRouteName:@"Publisher" HTTPHeaderParams:params queryParameters:nil credentials:NO completion:^(RKMappingResult *mappingResult, RKObjectRequestOperation *response, NSError *error) {
        completion(mappingResult.firstObject, response, error);
    }];
}

- (void)fetchTitlesForPublisher:(NSNumber*)publisherID page:(NSNumber *)page withCompletion:(void (^)(NSArray*, RKObjectRequestOperation*, NSError*))completion {
    
    NSString *params = [NSDictionary dictionaryWithKeysAndObjects:
                        @"publisherID", publisherID,
                        nil];
    
    NSDictionary *objectDictParams;
    if (![page isEqualToNumber:@1]) {
        objectDictParams = @{@"page" : [NSString stringWithFormat:@"%d", [page intValue]]};
    }
    
    [self GETWithRouteName:@"Titles for Publisher" HTTPHeaderParams:params queryParameters:objectDictParams credentials:NO completion:^(RKMappingResult *mappingResult, RKObjectRequestOperation *response, NSError *error) {
        
        if (!error) {
            for (LBXTitle *title in mappingResult.array) {
                [self saveAlternateIssuesWithIssue:title.latestIssue];
            }
        }
        completion(mappingResult.array, response, error);
    }];
}


// Users
- (void)registerWithEmail:(NSString*)email password:(NSString *)password passwordConfirm:(NSString *)passwordConfirm withCompletion:(void (^)(NSDictionary*, AFHTTPRequestOperation*, NSError*))completion {
    
    NSDictionary *parameters = @{@"email" : email, @"password" : password, @"password_confirm" : passwordConfirm};
    
    [self POSTWithRouteName:@"Register" HTTPHeaderParams:nil queryParameters:parameters credentials:NO completion:^(NSDictionary *resultDict, AFHTTPRequestOperation *response, NSError *error) {
        if (error) {
            NSString *errorJSONString = error.userInfo[@"NSLocalizedRecoverySuggestion"];
            NSData *data = [errorJSONString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            resultDict = jsonDict[@"errors"];
        }
        completion(resultDict, response, error);
    }];
}

- (void)deleteAccountWithCompletion:(void (^)(NSDictionary*, AFHTTPRequestOperation*, NSError*))completion {
    
    [self DELETEWithRouteName:@"Delete Account" HTTPHeaderParams:nil queryParameters:nil credentials:YES completion:^(NSDictionary *resultDict, AFHTTPRequestOperation *response, NSError *error) {
        
        completion(resultDict, response, error);
    }];
}


- (void)fetchLogInWithCompletion:(void (^)(LBXUser*, RKObjectRequestOperation*, NSError*))completion {
    [self GETWithRouteName:@"Login" HTTPHeaderParams:nil queryParameters:nil credentials:YES completion:^(RKMappingResult *mappingResult, RKObjectRequestOperation *response, NSError *error) {
        
        // Store the user ID
        LBXUser *user = mappingResult.firstObject;
        UICKeyChainStore *store = [UICKeyChainStore keyChainStore];
        
        [UICKeyChainStore setString:[NSString stringWithFormat:@"%@", user.userID] forKey:@"id"];
        [store synchronize];

        completion(mappingResult.firstObject, response, error);
    }];
}

- (void)fetchPullListWithCompletion:(void (^)(NSArray*, RKObjectRequestOperation*, NSError*))completion {
    
    UICKeyChainStore *store = [UICKeyChainStore keyChainStore];
    NSString *headerParams;
    if (store[@"id"]) {
        headerParams = [NSDictionary dictionaryWithKeysAndObjects:
                            @"userID", store[@"id"],
                            nil];
        
    }
    
    [self GETWithRouteName:@"User Pull List" HTTPHeaderParams:headerParams queryParameters:nil credentials:YES completion:^(RKMappingResult *mappingResult, RKObjectRequestOperation *response, NSError *error) {
        
        if (!error) {
            for (LBXTitle *title in mappingResult.array) {
                [self saveAlternateIssuesWithIssue:title.latestIssue];
            }
        }
        
        completion(mappingResult.array, response, error);
    }];
}

- (void)addTitleToPullList:(NSNumber*)titleID withCompletion:(void (^)(NSArray*, AFHTTPRequestOperation*, NSError*))completion {

    NSDictionary *headerParams = @{@"title_id" : [titleID stringValue]};
    
    [self POSTWithRouteName:@"Add Title to Pull List" HTTPHeaderParams:headerParams queryParameters:nil credentials:YES completion:^(NSDictionary *resultDict, AFHTTPRequestOperation *response, NSError *error) {
        
        NSArray *pullListArray = [NSArray sortedArray:[LBXPullListTitle MR_findAllSortedBy:nil ascending:YES] basedOffObjectProperty:@"name"];
        completion(pullListArray, response, error);
    }];
}

- (void)removeTitleFromPullList:(NSNumber*)titleID withCompletion:(void (^)(NSArray*, AFHTTPRequestOperation*, NSError*))completion {
    
    NSDictionary *headerParams = @{@"title_id" : [titleID stringValue]};
    
    // Remove the title from Core Data
    __block NSPredicate *predicate = [NSPredicate predicateWithFormat: @"titleID == %@", titleID];
    [LBXPullListTitle MR_deleteAllMatchingPredicate:predicate];
    
    [self DELETEWithRouteName:@"Add Title to Pull List" HTTPHeaderParams:headerParams queryParameters:nil credentials:YES completion:^(NSDictionary *resultDict, AFHTTPRequestOperation *response, NSError *error) {
        
        if (!error) {
            // Remove the title from the latest bundle
            NSArray *bundleArray = [LBXBundle MR_findAllSortedBy:@"bundleID" ascending:NO];
            if (bundleArray.count) {
                LBXBundle *bundle = bundleArray[0];
                predicate = [NSPredicate predicateWithFormat:@"bundleID == %@", bundle.bundleID];
                [LBXBundle MR_deleteAllMatchingPredicate:predicate];
            }
        }
        
        NSArray *pullListArray = [NSArray sortedArray:[LBXPullListTitle MR_findAllSortedBy:nil ascending:YES] basedOffObjectProperty:@"name"];
        completion(pullListArray, response, error);
    }];
}

- (void)fetchBundleResourcesWithCompletion:(void (^)(NSArray*, RKObjectRequestOperation*, NSError*))completion {

    UICKeyChainStore *store = [UICKeyChainStore keyChainStore];
    NSString *headerParams;
    if (store[@"id"]) {
        headerParams = [NSDictionary dictionaryWithKeysAndObjects:
                  @"userID", store[@"id"],
                  nil];
    }
    
    [self GETWithRouteName:@"Bundle Resources for User" HTTPHeaderParams:headerParams queryParameters:nil credentials:YES completion:^(RKMappingResult *mappingResult, RKObjectRequestOperation *response, NSError *error) {
        
        if (!error) {
            for (LBXBundle *bundle in mappingResult.array) {
                for (LBXIssue *issue in bundle.issues) {
                    [self saveAlternateIssuesWithIssue:issue];
                }
            }
        }
        
        completion(mappingResult.array, response, error);
    }];
}

- (void)fetchLatestBundleWithCompletion:(void (^)(LBXBundle*, RKObjectRequestOperation*, NSError*))completion {

    UICKeyChainStore *store = [UICKeyChainStore keyChainStore];
    NSString *headerParams;
    if (store[@"id"]) {
        headerParams = [NSDictionary dictionaryWithKeysAndObjects:
                  @"userID", store[@"id"],
                  nil];
        
    }
    
    [self GETWithRouteName:@"Latest Bundle" HTTPHeaderParams:headerParams queryParameters:nil credentials:YES completion:^(RKMappingResult *mappingResult, RKObjectRequestOperation *response, NSError *error) {
        
        LBXBundle *bundle = ((LBXBundle *)mappingResult.array[0]) ? ((LBXBundle *)mappingResult.array[0]) : nil;
        
        if (!error) {
            for (LBXIssue *issue in bundle.issues) {
                [self saveAlternateIssuesWithIssue:issue];
            }
        }
        
        completion(bundle, response, error);
    }];
}

// http://oleb.net/blog/2009/09/managing-the-network-activity-indicator/
+ (void)setNetworkActivityIndicatorVisible:(BOOL)setVisible {
    static NSUInteger kNetworkIndicatorCount = 0;
    
    if (setVisible) {
        kNetworkIndicatorCount++;
    }
    else {
        kNetworkIndicatorCount--;
    }
    
    // The assertion helps to find programmer errors in activity indicator management.
    // Since a negative NumberOfCallsToSetVisible is not a fatal error,
    // it should probably be removed from production code.
    NSAssert(kNetworkIndicatorCount >= 0, @"Network Activity Indicator was asked to hide more often than shown");
    
    // Display the indicator as long as our static counter is > 0.
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:(kNetworkIndicatorCount > 0)];
    });
}

#pragma mark Private Methods

- (void)saveAlternateIssuesWithIssue:(LBXIssue *)issue {
    // Save all the alternate issues
    for (NSDictionary *alternateIssueDict in issue.alternates) {
        // Create the alternate issue in the datastore if it's not there already
        LBXIssue *foundIssue = [LBXIssue MR_findFirstByAttribute:@"completeTitle" withValue:alternateIssueDict[@"complete_title"]];
        if (!foundIssue) {
            LBXIssue *alternateIssue = [LBXIssue MR_createEntity];
            alternateIssue.completeTitle = alternateIssueDict[@"complete_title"];
            alternateIssue.issueID = alternateIssueDict[@"id"];
            alternateIssue.isParent = alternateIssueDict[@"is_parent"];
            alternateIssue.title = issue.title;
            alternateIssue.issueNumber = issue.issueNumber;
            alternateIssue.publisher = issue.publisher;
            alternateIssue.releaseDate = issue.releaseDate;
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        }
    }
}

@end
