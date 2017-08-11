//
//  RecentPhotosTableViewController.m
//  Top Places
//
//  Created by 郝泽 on 2017/8/8.
//  Copyright © 2017年 JH. All rights reserved.
//

#import "RecentPhotosTableViewController.h"
#import "StorageHelper.h"

@interface RecentPhotosTableViewController ()

@end

@implementation RecentPhotosTableViewController

#pragma mark - Lifecycle
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.photos = self.storage.recentPhotos;
	[self.tableView reloadData];
}

@end
