//
//  RecentPhoto+Create.m
//  TopPlaces
//
//  Created by 郝泽 on 2017/8/19.
//  Copyright © 2017年 JH. All rights reserved.
//

#import "RecentPhoto+Create.h"
#import "Photo+CoreDataClass.h"

@implementation RecentPhoto (Create)

+ (RecentPhoto *)recentPhotoWithPhoto:(Photo *)photo inManagedObjectContext:(NSManagedObjectContext *)context {
	RecentPhoto *recentPhoto = [self recentPhotoWithPhoto:photo alreadyExistedInManagedObjectContext:context];
	if (!recentPhoto) {
		recentPhoto = [self recentPhotoWithPhoto:photo insertIntoManagedObjectContext:context];
	}
	recentPhoto.lastDate = [NSDate date];
	return recentPhoto;
}

+ (RecentPhoto *)recentPhotoWithPhoto:(Photo *)photo alreadyExistedInManagedObjectContext:(NSManagedObjectContext *)context {
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:RecentPhoto.entity.name];
	request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", photo.unique];
	NSError *error;
	NSArray *matches = [context executeFetchRequest:request error:&error];
	if (!matches || error) {
		NSLog(@"[%@ %@] executing fetch request error", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
		return nil;
	}
	if (matches.count > 1) {
		NSLog(@"[%@ %@] too many photos with ONE unique", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
	}
	return matches.firstObject;
}

+ (RecentPhoto *)recentPhotoWithPhoto:(Photo *)photo insertIntoManagedObjectContext:(NSManagedObjectContext *)context {
	RecentPhoto *result = [NSEntityDescription insertNewObjectForEntityForName:RecentPhoto.entity.name
														inManagedObjectContext:context];
	result.unique = photo.unique;
	result.title = photo.title;
	result.thumbnail = photo.thumbnail;
	result.descriptionContent = photo.descriptionContent;
	result.url = photo.url;
	result.thumbnailURL = photo.thumbnailURL;
	return result;
}
@end
