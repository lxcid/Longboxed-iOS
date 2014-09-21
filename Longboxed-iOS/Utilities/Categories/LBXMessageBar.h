//
//  LBXMessageBar.h
//  Longboxed-iOS
//
//  Created by johnrhickey on 8/10/14.
//  Copyright (c) 2014 Longboxed. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LBXMessageBar : NSObject

+ (void)displayError:(NSError *)error;
+ (void)successfulLogin;
+ (void)successfulLogout;
+ (void)incorrectCredentials;
+ (void)longboxedWebPageError;

@end