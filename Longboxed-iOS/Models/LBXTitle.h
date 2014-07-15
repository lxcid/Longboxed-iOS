//
//  LBXTitle.h
//  Longboxed-iOS
//
//  Created by johnrhickey on 7/6/14.
//  Copyright (c) 2014 Longboxed. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LBXPublisher.h"

@interface LBXTitle : NSObject

@property (nonatomic, copy) NSNumber *titleID;
@property (nonatomic, copy) NSNumber *issueCount;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, retain) LBXPublisher *publisher;
@property (nonatomic, copy) NSNumber *subscribers;

@end