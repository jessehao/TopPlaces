//
//  Place+Flickr.m
//  TopPlaces
//
//  Created by 郝泽 on 2017/8/17.
//  Copyright © 2017年 JH. All rights reserved.
//

#import "FlickrFetcher.h"
#import "Place+Flickr.h"

@implementation Place (Flickr)

+ (Place *)placeWithUnique:(NSString *)unique andPhotographer:(Photographer *)photographer inManagedObjectContext:(NSManagedObjectContext *)context {
	Place *place = [self placeWithUnique:unique alreadyExistedInManagedObjectContext:context];
	if (!place) {
		place = [self placeWithUnique:unique insertIntoManagedObjectContext:context];
	}
	if(![place.activePhotographers containsObject:photographer]){
		[place addActivePhotographersObject:photographer];
		place.countOfActivePhotographers++;
	}
	return place;
}

+ (Place *)placeWithUnique:(NSString *)unique alreadyExistedInManagedObjectContext:(NSManagedObjectContext *)context {
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:Place.entity.name];
	request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", unique];
	NSError *error;
	NSArray *matches = [context executeFetchRequest:request error:&error];
	if (!matches || error) {
		NSLog(@"[%@ %@] executing fetch request error", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
		return nil;
	}
	if (matches.count > 1) {
		NSLog(@"[%@ %@] too many places with ONE unique", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
	}
	return matches.firstObject;
}

+ (Place *)placeWithUnique:(NSString *)unique insertIntoManagedObjectContext:(NSManagedObjectContext *)context {
	Place *result = [NSEntityDescription insertNewObjectForEntityForName:Place.entity.name
												  inManagedObjectContext:context];
	NSDictionary *raw = [self rawWithUnique:unique];
	result.unique = unique;
	result.name = [raw valueForKeyPath:@"place.name"];
	return result;
}

+ (NSDictionary *)rawWithUnique:(NSString *)unique {
	NSURL *url = [FlickrFetcher URLforInformationAboutPlace:unique];
	NSData *data = [NSData dataWithContentsOfURL:url];
	return [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
}
@end
