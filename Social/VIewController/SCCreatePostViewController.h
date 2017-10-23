//
//  SCCreatePostViewController.h
//  Social
//
//  Created by yujie cao on 10/8/17.
//  Copyright © 2017 yujie cao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCCreatePostViewControllerDelegate <NSObject>

- (void)didCreatePost;

@end
@interface SCCreatePostViewController : UIViewController

@property (nonatomic, weak) id<SCCreatePostViewControllerDelegate> delegate;

@end

