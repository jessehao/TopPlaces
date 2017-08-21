//
//  RecentPhotosTableViewController.m
//  Top Places
//
//  Created by 郝泽 on 2017/8/8.
//  Copyright © 2017年 JH. All rights reserved.
//

#import "RecentPhotosTableViewController.h"
#import "RecentPhoto+CoreDataClass.h"
#import "DBAvailability.h"

@interface RecentPhotosTableViewController ()

@end

@implementation RecentPhotosTableViewController

@synthesize managedObjectContext = _managedObjectContext;

- (void)setManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
	_managedObjectContext = managedObjectContext;
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:RecentPhoto.entity.name];
	request.predicate = nil;
	request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"lastDate"
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

@end
