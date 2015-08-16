//
//  LBXTitle.m
//  Longboxed-iOS
//
//  Created by johnrhickey on 7/6/14.
//  Copyright (c) 2014 Longboxed. All rights reserved.
//

#import "LBXTitle.h"
#import "LBXPullListTitle.h"
@implementation LBXTitle

@dynamic titleID;
@dynamic issueCount;
@dynamic name;
@dynamic publisher;
@dynamic subscribers;
@dynamic latestIssue;

- (NSString *)description
{
    return [NSString stringWithFormat:@"Title: %@\nID: %@\nPublisher: %@\nSubscribers: %@\nIssue Count: %@", self.name, self.titleID, self.publisher.name, self.subscribers, self.issueCount];
}

- (BOOL)isInPullList {
    LBXPullListTitle *title = [LBXPullListTitle MR_findFirstByAttribute:@"titleID" withValue:self.titleID inContext:[NSManagedObjectContext MR_defaultContext]];
    if (title) return YES;
    return NO;
}

@end
