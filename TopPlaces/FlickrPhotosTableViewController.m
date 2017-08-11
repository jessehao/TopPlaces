//
//  FlickrPhotosTableViewController.m
//  Top Places
//
//  Created by 郝泽 on 2017/8/8.
//  Copyright © 2017年 JH. All rights reserved.
//

#import "FlickrPhotosTableViewController.h"
#import "StorageHelper.h"
#import "FlickrHelper.h"
#import "FlickrPhoto.h"
#import "ImageViewController.h"

@interface FlickrPhotosTableViewController () <UISplitViewControllerDelegate>

@end

@implementation FlickrPhotosTableViewController

- (FlickrHelper *)helper {
	return [FlickrHelper sharedHelper];
}

- (StorageHelper *)storage {
	return [StorageHelper sharedHelper];
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
	[super viewDidLoad];
	self.splitViewController.delegate = self;
	[self fetchPhotos];
}

#pragma mark - Table View Data Source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.photos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FLICKR_PHOTOS_CELL_IDENTIFIER forIndexPath:indexPath];
    FlickrPhoto *photo = self.photos[indexPath.row];
	cell.textLabel.text = photo.title && ![photo.title isEqualToString:@""] ? photo.title : (photo.descriptionContent && ![photo.descriptionContent isEqualToString:@""] ? photo.descriptionContent : @"Unknown");
	cell.detailTextLabel.text = [photo.descriptionContent isEqualToString:cell.textLabel.text] ? nil : photo.descriptionContent;
    return cell;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:FLICKR_PHOTOS_TO_IMAGE_VIEW_SEGUE_IDENTIFIER] &&
        [sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath && [segue.destinationViewController isKindOfClass:[UINavigationController class]]) {
			ImageViewController *ivc = (ImageViewController *)[(UINavigationController *)segue.destinationViewController topViewController];
			if ([ivc isKindOfClass:[ImageViewController class]]) {
				[self prepareImageViewController:ivc toDisplayPhoto:self.photos[indexPath.row]];
				[self.storage addPhoto:self.photos[indexPath.row]];
			}
        }
    }
}

- (void)prepareImageViewController:(ImageViewController *)ivc toDisplayPhoto:(FlickrPhoto *)photo {
	ivc.imageURL = photo.url;
	ivc.title = photo.title;
	ivc.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
	ivc.navigationItem.leftItemsSupplementBackButton = YES;
}


#pragma mark - Split View
- (BOOL)splitViewController:(UISplitViewController *)splitViewController showDetailViewController:(UIViewController *)vc sender:(id)sender {
	if (splitViewController.collapsed) {
		ImageViewController *detailImageVC = (ImageViewController *)[(UINavigationController *)vc topViewController];
		[self.navigationController pushViewController:detailImageVC animated:YES];
		return YES;
	}
	return NO;
}

#pragma mark - Abstract
- (void)fetchPhotos{ return; }

@end
