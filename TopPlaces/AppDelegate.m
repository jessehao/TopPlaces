//
//  AppDelegate.m
//  Top Places
//
//  Created by 郝泽 on 2017/8/8.
//  Copyright © 2017年 JH. All rights reserved.
//

#import "AppDelegate.h"
#import "StorageHelper.h"

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


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
	[[StorageHelper sharedHelper] save];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
