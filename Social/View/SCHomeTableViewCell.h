//
//  SCHomeTableViewCell.h
//  Social
//
//  Created by yujie cao on 9/30/17.
//  Copyright © 2017 yujie cao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCPost;

@interface SCHomeTableViewCell : UITableViewCell
- (void)loadCellWithPost:(SCPost *)post;
+ (CGFloat)cellHeight;

@end
