//
//  FlickrHelper.m
//  TopPlaces
//
//  Created by 郝泽 on 2017/8/8.
//  Copyright © 2017年 JH. All rights reserved.
//

#import "FlickrHelper.h"
#import "FlickrFetcher.h"
#import "FlickrPlace.h"
#import "FlickrPhoto.h"

@interface FlickrHelper()

@property (strong, nonatomic, readwrite) NSMutableDictionary<NSString *, NSMutableArray<FlickrPlace *> *> *places;

@end

@implementation FlickrHelper

- (NSMutableDictionary<NSString *,NSMutableArray<FlickrPlace *> *> *)places {
	if (!_places) {
		_places = [NSMutableDictionary dictionary];
	}
	return _places;
}

#pragma mark - Operations

- (void)refreshPlaces {
	[self.places removeAllObjects];
	NSArray *rawPlaces = [self fetchRawPlaces];
	for (NSDictionary *rawPlace in rawPlaces) {
		FlickrPlace *place = [[FlickrPlace alloc] initWithRaw:rawPlace];
		if (!self.places[place.country]) {
			[self.places setValue:[NSMutableArray array] forKey:place.country];
		}
		NSMutableArray *cities = self.places[place.country];
		[cities addObject:place];
	}
	[self sort];
}

- (NSArray<FlickrPhoto *> *)photosFromPlace:(FlickrPlace *)place {
	NSArray *rawPhotos = [self fetchRawPhotosFromPlace:place];
	NSMutableArray *photos = [NSMutableArray array];
	for (NSDictionary *rawPhoto in rawPhotos) {
		FlickrPhoto *photo = [[FlickrPhoto alloc] initWithRaw:rawPhoto];
		[photos addObject:photo];
	}
	return photos;
}

- (NSArray *)fetchRawPhotosFromPlace:(FlickrPlace *)place {
	NSURL *url = [FlickrFetcher URLforPhotosInPlace:place.ID maxResults:50];
	NSDictionary *propertyListResult = [self fetchJSONObjectFromURL:url];
	return [propertyListResult valueForKeyPath:FLICKR_RESULTS_PHOTOS];
}

- (NSArray *)fetchRawPlaces {
	NSURL *url = [FlickrFetcher URLforTopPlaces];
	NSDictionary *propertyListResult = [self fetchJSONObjectFromURL:url];
	return [propertyListResult valueForKeyPath:FLICKR_RESULTS_PLACES];
}

- (NSDictionary *)fetchJSONObjectFromURL:(NSURL *)url {
	NSData *jsonResults = [NSData dataWithContentsOfURL:url];
	return [NSJSONSerialization JSONObjectWithData:jsonResults
										   options:0
											 error:NULL];
}

- (void)sort {
	for (NSString *key in self.places.allKeys) {
		NSMutableArray *cities = self.places[key];
		[cities sortUsingSelector:@selector(compare:)]; // crashed here
	}
}

#pragma mark - CLASS

+ (FlickrHelper *)sharedHelper {
	static FlickrHelper *shared;
	if (!shared) {
		shared = [[FlickrHelper alloc] init];
	}
	return shared;
}
@end
