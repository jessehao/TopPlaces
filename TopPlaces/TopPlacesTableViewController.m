//
//  TopPlacesTableViewController.m
//  Top Places
//
//  Created by 郝泽 on 2017/8/8.
//  Copyright © 2017年 JH. All rights reserved.
//

#import "TopPlacesTableViewController.h"
#import "CityPhotosTableViewController.h"
#import "FlickrHelper.h"
#import "FlickrPlace.h"

@interface TopPlacesTableViewController ()
@property (strong, nonatomic, readonly) FlickrHelper *helper;
@property (strong, nonatomic, readonly) NSDictionary<NSString *, NSMutableArray<FlickrPlace *> *> *places;
@property (strong, nonatomic) NSArray<NSString *> *sortedCountries;
@end

@implementation TopPlacesTableViewController

- (NSArray<NSString *> *)sortedCountries {
	if (!_sortedCountries) {
		_sortedCountries = [self.places.allKeys sortedArrayUsingSelector:@selector(compare:)];
	}
	return _sortedCountries;
}

- (FlickrHelper *)helper {
	return [FlickrHelper sharedHelper];
}

- (NSDictionary<NSString *, NSMutableArray<FlickrPlace *> *> *)places {
	return self.helper.places;
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
	[self fetchPlaces];
}

#pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.sortedCountries.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return self.sortedCountries[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.places[self.sortedCountries[section]].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TOP_PLACES_CELL_IDENTIFIER forIndexPath:indexPath];
    FlickrPlace *place = self.places[self.sortedCountries[indexPath.section]][indexPath.row];
	cell.textLabel.text = place.city ? place.city : @"Unknown";
	cell.detailTextLabel.text = place.province;
    return cell;
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	CityPhotosTableViewController *vc = segue.destinationViewController;
	if ([segue.identifier isEqualToString:TOP_PLACES_TO_FLICKR_PHOTOS_SEGUE_INDENTIFIER] &&
		[vc isKindOfClass:[CityPhotosTableViewController class]]) {
		NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
		vc.place = self.places[self.sortedCountries[indexPath.section]][indexPath.row];
	}
}

#pragma mark - Actions
- (IBAction)fetchPlaces {
    [self.refreshControl beginRefreshing];
    dispatch_queue_t queue = dispatch_queue_create("fetch places queue", NULL);
    dispatch_async(queue, ^{
		[self.helper refreshPlaces];
        dispatch_async(dispatch_get_main_queue(), ^{
			self.sortedCountries = nil;
			[self.tableView reloadData];
            [self.refreshControl endRefreshing];
        });
    });
}
@end
