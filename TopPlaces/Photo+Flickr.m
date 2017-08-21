//
//  Photo+Flickr.m
//  TopPlaces
//
//  Created by 郝泽 on 2017/8/17.
//  Copyright © 2017年 JH. All rights reserved.
//

#import "FlickrFetcher.h"
#import "Photo+Flickr.h"
#import "Place+Flickr.h"
#import "Photographer+Create.h"



@implementation Photo (Flickr)
+ (Photo *)photoWithRaw:(NSDictionary *)raw inManagedObjectContext:(NSManagedObjectContext *)context {
	Photo *photo = [self photoWithRaw:raw alreadyExistedInManagedObjectContext:context];
	if (!photo) {
		photo = [self photoWithRaw:raw insertIntoManagedObjectContext:context];
	}
	return photo;
}

+ (Photo *)photoWithRaw:(NSDictionary *)raw alreadyExistedInManagedObjectContext:(NSManagedObjectContext *)context {
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:Photo.entity.name];
	NSString *unique = raw[FLICKR_PHOTO_ID];
	request.predicate = [NSPredicate predicateWithFormat:@"unique = %@", unique];
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

+ (Photo *)photoWithRaw:(NSDictionary *)raw insertIntoManagedObjectContext:(NSManagedObjectContext *)context {
	Photo *result = [NSEntityDescription insertNewObjectForEntityForName:Photo.entity.name
												  inManagedObjectContext:context];
	result.unique = raw[FLICKR_PHOTO_ID];
	result.title = raw[FLICKR_PHOTO_TITLE];
	result.descriptionContent = raw[FLICKR_PHOTO_DESCRIPTION];
	result.thumbnailURL = [[FlickrFetcher URLforPhoto:raw format:FlickrPhotoFormatSquare] absoluteString];
	result.url = [[FlickrFetcher URLforPhoto:raw format:FlickrPhotoFormatLarge] absoluteString];
	result.uploadDate = [NSDate dateWithTimeIntervalSince1970:[raw[FLICKR_PHOTO_UPLOAD_DATE] doubleValue]];
	result.owner = [Photographer photographerWithName:raw[FLICKR_PHOTO_OWNER] inManagedObjectContext:context];
	result.place = [Place placeWithUnique:raw[FLICKR_PHOTO_PLACE_ID] andPhotographer:result.owner inManagedObjectContext:context];
	return result;
}

+ (NSArray<NSDictionary *> *)rawPhotosAtURL:( NSURL * _Nonnull )url {
	NSData *data = [NSData dataWithContentsOfURL:url];
	if (!data) {
		return nil;
	}
	NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
	return [json valueForKeyPath:FLICKR_RESULTS_PHOTOS];
}

+ (void)loadPhotosFromRawArray:(NSArray<NSDictionary *> *)rawPhotos inManagedObjectContext:(NSManagedObjectContext *)context {
	for (NSDictionary *raw in rawPhotos) {
		[self photoWithRaw:raw inManagedObjectContext:context];
	}
}

+ (void)loadPhotosFromURL:(NSURL *)url inManagedObjectContext:(NSManagedObjectContext *)context {
	[self loadPhotosFromRawArray:[self rawPhotosAtURL:url]
		  inManagedObjectContext:context];
}
@end
