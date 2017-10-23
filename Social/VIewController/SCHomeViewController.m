//
//  SCHomeViewController.m
//  Social
//
//  Created by yujie cao on 9/30/17.
//  Copyright © 2017 yujie cao. All rights reserved.
//


#import "SCHomeViewController.h"
#import "SCHomeTableViewCell.h"
#import "SCPost.h"
#import "SCSignInViewController.h"
#import "SCUser.h"
#import "SCCreatePostViewController.h"
#import "AFNetworking.h"
#import "SCLocationManager.h"
#import "SCPostManager.h"
#import "SCPostDetailViewController.h"
#import <MapKit/MapKit.h>

static NSString * const SCHomeCellIdentifier = @"SCHomeCellIdentifier";

@interface SCHomeViewController ()<UITableViewDelegate, UITableViewDataSource,SCCreatePostViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) NSArray<SCPost *> *posts;
@property (assign, nonatomic) CLLocationCoordinate2D coordinate;


@end

@implementation SCHomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupTableView];
    
    // load data
    [self loadPosts];
    
    // load UI
    [self setupUI];
    
    // request location access
    [self updateLocation];
    
    // add observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadPosts) name:SCLocationUpdateNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // check user login or not
    [self userLoginIfRequire];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark -- public
- (void)loadResultPageWithPosts:(NSArray <SCPost *>*)posts
{
    self.posts = posts;
    [self.tableView reloadData];
}

#pragma mark -- private

- (void)userLoginIfRequire
{
    if (![SCUser isUserLogin]) {
        SCSignInViewController *signInViewController = [[SCSignInViewController alloc] initWithNibName:NSStringFromClass([SCSignInViewController class]) bundle:nil];
        [self presentViewController:signInViewController animated:YES completion:nil];
    }
}

- (void)updateLocation
{
    if (![SCLocationManager isLocationServicesEnabled]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Location Required", nil) message:NSLocalizedString(@"Location is required for this app", nil) preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            NSLog(@"OK");
        }];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        SCLocationManager *locationManager  = [SCLocationManager sharedManager];
        [locationManager startLoadUserLocation];
    }
}

- (void)updateUserLocation
{
    [self loadPosts];
}

#pragma mark - UI
- (void)setupUI
{
    [self setupTableView];
    [self setupNavigationBarUI];
}

- (void)setupTableView
{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SCHomeTableViewCell class]) bundle:nil] forCellReuseIdentifier:SCHomeCellIdentifier];
}

- (void)setupNavigationBarUI
{
    self.title = NSLocalizedString(@"Home", nil);
    self.navigationController.navigationBar.tintColor = [UIColor darkTextColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"PostEvent"] style:UIBarButtonItemStyleDone target:self action:@selector(showCreatePostPage)];
}

#pragma mark - action
- (void)showCreatePostPage
{
    // TODO
    SCCreatePostViewController *createPostViewController = [[SCCreatePostViewController alloc] initWithNibName:NSStringFromClass([SCCreatePostViewController class]) bundle:nil];
    createPostViewController.delegate = self;
    [self.navigationController pushViewController:createPostViewController animated:YES];
}
#pragma mark - SCCreatePostViewControllerDelegate
- (void)didCreatePost
{
    [self loadPosts];
}


#pragma mark - API
- (void)loadPosts
{
    __weak typeof(self) weakSelf = self;
    CLLocation *location = [[SCLocationManager sharedManager] getUserCurrentLocation];
    NSInteger range = 30000;
    [SCPostManager getPostsWithLocation:location range:range andCompletion:^(NSArray<SCPost *> *posts, NSError *error) {
        if (posts) {
            weakSelf.posts = posts;
            [weakSelf.tableView reloadData];
            NSLog(@"get posts count:%ld", (long)posts.count);
        }
        else {
            NSLog(@"error: %@", error);
        }
    }];
    [self.refreshControl endRefreshing];
//    SCPost *post1 = [SCPost new];
//    post1.username = @"Jonathan";
//    post1.message = @"Hi, my name is Jonathan.";
//    SCPost *post2 = [SCPost new];
//    post2.username = @"Steve";
//    post2.message = @"Hi, nice to meet you!";
//    SCPost *post3 = [SCPost new];
//    post3.username = @"Jorge";
//    post3.message = @"Do we have class today?";
//    self.posts = @[post1, post2, post3];
//    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.posts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SCHomeTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:SCHomeCellIdentifier forIndexPath:indexPath];
    [cell loadCellWithPost:self.posts[indexPath.row]];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [SCHomeTableViewCell cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.posts.count > indexPath.row) {
        SCPost *post =[self.posts objectAtIndex:indexPath.row];
        SCPostDetailViewController *detailViewController = [[SCPostDetailViewController alloc] initWithNibName:NSStringFromClass([SCPostDetailViewController class]) bundle:nil];
        [detailViewController loadDetailViewWithPost:post];
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
}
@end
