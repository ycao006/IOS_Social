//
//  SCPostDetailViewController.h
//  Social
//
//  Created by yujie cao on 10/8/17.
//  Copyright © 2017 yujie cao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCPost;

@interface SCPostDetailViewController : UIViewController

- (void)loadDetailViewWithPost:(SCPost *)post;

@end
