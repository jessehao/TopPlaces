//
//  CityPhotosTableViewController.m
//  Top Places
//
//  Created by 郝泽 on 2017/8/8.
//  Copyright © 2017年 JH. All rights reserved.
//

#import "CityPhotosTableViewController.h"
#import "FlickrHelper.h"
#import "FlickrPlace.h"
#import "StorageHelper.h"

@interface CityPhotosTableViewController ()

@end

@implementation CityPhotosTableViewController

#pragma mark - Lifecycle
- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = self.place.city;
}

#pragma mark - Actions
- (IBAction)fetchPhotos {
	[self.refreshControl beginRefreshing];
	dispatch_queue_t queue = dispatch_queue_create("fetch photos queue", NULL);
	dispatch_async(queue, ^{
		self.photos = [self.helper photosFromPlace:self.place];
		dispatch_async(dispatch_get_main_queue(), ^{
			[self.tableView reloadData];
			[self.refreshControl endRefreshing];
		});
	});
}

@end
