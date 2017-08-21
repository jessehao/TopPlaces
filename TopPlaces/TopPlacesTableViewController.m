//
//  TopPlacesTableViewController.m
//  Top Places
//
//  Created by 郝泽 on 2017/8/8.
//  Copyright © 2017年 JH. All rights reserved.
//

#import "TopPlacesTableViewController.h"
#import "CityPhotosTableViewController.h"
#import "DBAvailability.h"
#import "Place+CoreDataClass.h"

@interface TopPlacesTableViewController ()
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end

@implementation TopPlacesTableViewController

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
	_managedObjectContext = managedObjectContext;
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:Place.entity.name];
	request.predicate = nil;
	request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"countOfActivePhotographers" // wrong format!
															  ascending:NO]];
	self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
																		managedObjectContext:managedObjectContext
																		  sectionNameKeyPath:nil
																				   cacheName:nil];
}

#pragma mark - C&D
- (void)awakeFromNib {
	[super awakeFromNib];
	[self setup];
}

- (void)setup {
	[[NSNotificationCenter defaultCenter] addObserverForName:DBA_NOTIFICATION_CONTEXT_SET
													  object:nil
													   queue:nil
												  usingBlock:^(NSNotification * _Nonnull note) {
													  self.managedObjectContext = note.userInfo[DBA_USERINFO_CONTEXT];
												  }];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Table View Data Source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TOP_PLACES_CELL_IDENTIFIER forIndexPath:indexPath];
    Place *place = [self.fetchedResultsController objectAtIndexPath:indexPath];
	cell.textLabel.text = place.name;
	cell.detailTextLabel.text = [NSString stringWithFormat:@"Active Photographers Number: %lu", place.activePhotographers.count];
    return cell;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	CityPhotosTableViewController *vc = segue.destinationViewController;
	if ([segue.identifier isEqualToString:TOP_PLACES_TO_FLICKR_PHOTOS_SEGUE_INDENTIFIER] &&
		[vc isKindOfClass:[CityPhotosTableViewController class]]) {
		NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
		vc.place = [self.fetchedResultsController objectAtIndexPath:indexPath];
		vc.managedObjectContext = self.managedObjectContext;
	}
}

#pragma mark - Actions
- (IBAction)fetchPlaces {
//    [self.refreshControl beginRefreshing];
//    dispatch_queue_t queue = dispatch_queue_create("fetch places queue", NULL);
//    dispatch_async(queue, ^{
//		[self.helper refreshPlaces];
//        dispatch_async(dispatch_get_main_queue(), ^{
//			self.sortedCountries = nil;
//			[self.tableView reloadData];
//            [self.refreshControl endRefreshing];
//        });
//    });
}
@end
