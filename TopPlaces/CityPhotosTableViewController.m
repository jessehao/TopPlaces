//
//  CityPhotosTableViewController.m
//  Top Places
//
//  Created by 郝泽 on 2017/8/8.
//  Copyright © 2017年 JH. All rights reserved.
//

#import "CityPhotosTableViewController.h"
#import "Photo+CoreDataClass.h"
#import "Place+CoreDataClass.h"

@interface CityPhotosTableViewController ()

@end

@implementation CityPhotosTableViewController

@synthesize managedObjectContext = _managedObjectContext;

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
	_managedObjectContext = managedObjectContext;
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:Photo.entity.name];
	request.predicate = [NSPredicate predicateWithFormat:@"place = %@", self.place];
	request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"uploadDate"
															  ascending:YES]];
	self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
																		managedObjectContext:managedObjectContext
																		  sectionNameKeyPath:nil
																				   cacheName:nil];
}

#pragma mark - Lifecycle
- (void)viewDidLoad {
	[super viewDidLoad];
	self.title = self.place.name;
}

@end
