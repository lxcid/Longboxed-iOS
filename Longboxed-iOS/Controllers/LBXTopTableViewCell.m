//
//  TableViewCell.m
//  Pulse
//
//  Created by Bushra on 7/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LBXTopTableViewCell.h"
#import "ActualTableViewCell.h"
#import "LBXDashboardViewController.h"
#import "LBXIssue.h"
#import "LBXControllerServices.h"

#import "UIImage+LBXCreateImage.h" 

#import <UIImageView+AFNetworking.h>
#import <Doppelganger.h>

@implementation LBXTopTableViewCell
@synthesize horizontalTableView;

- (void)awakeFromNib {
    // Initialization code
    self.horizontalTableView.frame = CGRectMake(self.horizontalTableView.frame.origin.x, self.horizontalTableView.frame.origin.y, 0, self.horizontalTableView.frame.size.height);
    self.horizontalTableView.rowHeight = 200;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reloadTableView)
                                                 name:@"reloadTopTableView"
                                               object:nil];
}

- (void)reloadTableView
{
    if (_contentArray.count && _previousContentArray.count) {
        NSArray *diffs = [WMLArrayDiffUtility diffForCurrentArray:_contentArray
                                                    previousArray:_previousContentArray];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.horizontalTableView wml_applyBatchChanges:diffs
                                                  inSection:0
                                           withRowAnimation:UITableViewRowAnimationFade];
        });
    }
    else [self.horizontalTableView reloadData];
}

- (void)setContentArray:(NSArray *)newContentArray {
    _previousContentArray = _contentArray;
    _contentArray = newContentArray;
}

- (NSString *) reuseIdentifier {
    return @"Cell";
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"ActualTableViewCell";
    ActualTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"ActualTableViewCell"
                                                     owner:self options:nil];
        for (id oneObject in nib) if ([oneObject isKindOfClass:[ActualTableViewCell class]])
            cell = (ActualTableViewCell *)oneObject;
    }
    
    LBXIssue *issue = [_contentArray objectAtIndex:indexPath.row];
    
    __weak typeof(cell) weakCell = cell;
    [cell.coverImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:issue.coverImage]] placeholderImage:[UIImage defaultCoverImage] success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        
        [UIView transitionWithView:weakCell.coverImage
                          duration:0.5f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{[weakCell.coverImage setImage:image];}
                        completion:NULL];
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        [UIView transitionWithView:weakCell.coverImage
                          duration:0.5f
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{[weakCell.coverImage setImage:[UIImage defaultCoverImage]];}
                        completion:NULL];
    }];
    
    [cell.titleName setText:issue.completeTitle];
    CGAffineTransform rotate = CGAffineTransformMakeRotation(M_PI_2);
    cell.transform = rotate;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.horizontalTableView.frame.size.height / 1.7;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LBXIssue *issue = [_contentArray objectAtIndex:indexPath.row];
    ActualTableViewCell *cell = (ActualTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSDictionary *dict = @{@"issue" : issue,
                           @"image" : cell.coverImage.image};
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"pushToIssueWithDict"
     object:self userInfo:dict];
}



@end
