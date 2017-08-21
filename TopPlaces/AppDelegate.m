//
//  AppDelegate.m
//  Top Places
//
//  Created by 郝泽 on 2017/8/8.
//  Copyright © 2017年 JH. All rights reserved.
//

#import "AppDelegate.h"
//#import "StorageHelper.h"
#import "DBAvailability.h"
#import "DataHelper.h"
#import "DownloadHelper.h"

@interface AppDelegate () <UISplitViewControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic, readonly) UISplitViewController *splitViewController;
@property (weak, nonatomic, readonly) UITabBarController *masterTabbar;
@property (weak, nonatomic, readonly) UINavigationController *topPlaceNavigation;
@property (weak, nonatomic, readonly) UITableViewController *topPlaceTableView;
@property (weak, nonatomic, readonly) UINavigationController *recentNavigation;
@property (weak, nonatomic, readonly) UITableViewController *recentTableView;
@end

@implementation AppDelegate

- (UISplitViewController *)splitViewController {
	return (UISplitViewController *)self.window.rootViewController;
}

- (UITabBarController *)masterTabbar {
	return (UITabBarController *)self.splitViewController.viewControllers.firstObject;
}

- (UINavigationController *)topPlaceNavigation {
	return self.masterTabbar.viewControllers.firstObject;
}

- (UITableViewController *)topPlaceTableView {
	return (UITableViewController *)self.topPlaceNavigation.viewControllers.firstObject;
}

- (UINavigationController *)recentNavigation {
	return self.masterTabbar.viewControllers.lastObject;
}

- (UITableViewController *)recentTableView {
	return (UITableViewController *)self.recentNavigation.viewControllers.firstObject;
}

#pragma mark - C&D
- (instancetype)init {
	self = [super init];
	if (self) {
		[self setup];
	}
	return self;
}

- (void)setup {
	[DataHelper sharedHelper];
	[[NSNotificationCenter defaultCenter] addObserverForName:DBA_NOTIFICATION_CONTEXT_SET
													  object:nil
													   queue:nil
												  usingBlock:^(NSNotification * _Nonnull note) {
													  [[DownloadHelper sharedHelper] startDownload];
												  }];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - App

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
	self.topPlaceNavigation.delegate = self;
	self.recentNavigation.delegate = self;
    self.splitViewController.delegate = self;
	self.masterTabbar.title = APP_NAME;
	self.topPlaceTableView.title = APP_NAME;
	self.recentTableView.title = APP_RECENT_NAME;
    return YES;
}

#pragma mark Background Fetch
- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
	[[DownloadHelper sharedHelper] startDownloadWaitTillFinished];
	completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - Split view

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    return YES;
}

#pragma mark - Navigation
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
	self.masterTabbar.title = viewController.title;
}

@end
