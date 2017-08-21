//
//  FlickrPhotosTableViewController.m
//  Top Places
//
//  Created by 郝泽 on 2017/8/8.
//  Copyright © 2017年 JH. All rights reserved.
//

#import "FlickrPhotosTableViewController.h"
#import "ImageViewController.h"
#import "DBAvailability.h"
#import "Photo+CoreDataClass.h"
#import "RecentPhoto+Create.h"

@interface FlickrPhotosTableViewController () <UISplitViewControllerDelegate>
@end

@implementation FlickrPhotosTableViewController

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
	_managedObjectContext = managedObjectContext;
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:Photo.entity.name];
	request.predicate = nil;
	request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"uploadDate"
															  ascending:YES]];
	self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
																		managedObjectContext:managedObjectContext
																		  sectionNameKeyPath:nil
																				   cacheName:nil];
}

#pragma mark - Lifecycle

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.splitViewController.delegate = self;
}

#pragma mark - Table View Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:FLICKR_PHOTOS_CELL_IDENTIFIER forIndexPath:indexPath];
	AbstractPhoto *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
	cell.textLabel.text = photo.title && ![photo.title isEqualToString:@""] ? photo.title : (photo.descriptionContent && ![photo.descriptionContent isEqualToString:@""] ? photo.descriptionContent : @"Unknown");
	cell.detailTextLabel.text = [photo.descriptionContent isEqualToString:cell.textLabel.text] ? nil : photo.descriptionContent;
	NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:photo.thumbnailURL]];
	cell.imageView.image = [UIImage imageWithData:data];
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
				Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
				[self prepareImageViewController:ivc toDisplayPhoto:photo];
				[RecentPhoto recentPhotoWithPhoto:photo inManagedObjectContext:self.managedObjectContext];
			}
        }
    }
}

- (void)prepareImageViewController:(ImageViewController *)ivc toDisplayPhoto:(Photo *)photo {
	ivc.imageURL = [NSURL URLWithString:photo.url];
	ivc.title = photo.title;
	ivc.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
	ivc.navigationItem.leftItemsSupplementBackButton = YES;
}


#pragma mark - Split View Delegate
- (BOOL)splitViewController:(UISplitViewController *)splitViewController showDetailViewController:(UIViewController *)vc sender:(id)sender {
	if (splitViewController.collapsed) {
		ImageViewController *detailImageVC = (ImageViewController *)[(UINavigationController *)vc topViewController];
		[self.navigationController pushViewController:detailImageVC animated:YES];
		return YES;
	}
	return NO;
}

@end
