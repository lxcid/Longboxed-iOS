//
//  LBXPublisherDetailView.h
//  Longboxed-iOS
//
//  Created by johnrhickey on 8/23/14.
//  Copyright (c) 2014 Longboxed. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LBXPublisherDetailView : UIView

@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIButton *publisherButton;
@property (nonatomic, weak) IBOutlet UILabel *latestIssueLabel;
@property (nonatomic, weak) IBOutlet UILabel *issuesAndSubscribersLabel;
@property (nonatomic, weak) IBOutlet UIImageView *latestIssueImageView;
@property (nonatomic, weak) IBOutlet UIButton *addToPullListButton;

@end
