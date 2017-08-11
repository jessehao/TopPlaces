//
//  StorageUtilities.m
//  TopPlaces
//
//  Created by 郝泽 on 2017/8/8.
//  Copyright © 2017年 JH. All rights reserved.
//

#import "StorageHelper.h"
#import "FlickrPhoto.h"

@interface StorageHelper()
@property (nonatomic, readwrite) BOOL changed;
@property (strong, nonatomic) NSMutableArray<FlickrPhoto *> *recentPhotos;
@end

@implementation StorageHelper

- (NSMutableArray<FlickrPhoto *> *)recentPhotos {
	if (!_recentPhotos) {
		_recentPhotos = [NSMutableArray array];
		NSMutableArray<NSDictionary *> *rawPhotos = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:STORAGE_RECENT_PHOTOS_KEY];
		for (NSDictionary *raw in rawPhotos) {
			FlickrPhoto *photo = [[FlickrPhoto alloc] initWithRaw:raw];
			[_recentPhotos addObject:photo];
		}
	}
	return _recentPhotos;
}

#pragma mark - Initialization
- (instancetype)init {
	self = [super init];
	if (self) {
		self.changed = NO;
	}
	return self;
}

#pragma mark - Operations

- (void)addPhoto:(FlickrPhoto *)photo {
	NSInteger index = [self containsPhoto:photo];
	if (index == 0) {
		return;
	}
	if (index > 0) {
		[self.recentPhotos removeObjectAtIndex:index];
	} else if (self.recentPhotos.count >= STORAGE_RECENT_PHOTOS_CAPACITY ) {
		[self.recentPhotos removeLastObject];
	}
	[self.recentPhotos insertObject:photo atIndex:0];
	self.changed = YES;
}

- (void)save {
	if (self.changed) {
		NSMutableArray<NSDictionary *> *rawPhotos = [NSMutableArray array];
		for (FlickrPhoto *photo in self.recentPhotos) {
			[rawPhotos addObject:photo.raw];
		}
		[[NSUserDefaults standardUserDefaults] setObject:rawPhotos forKey:STORAGE_RECENT_PHOTOS_KEY];
		self.changed = NO;
	}
}

- (NSInteger)containsPhoto:(FlickrPhoto *)photo {
	for (int i = 0; i<self.recentPhotos.count; i++) {
		if([self.recentPhotos[i].ID isEqualToString:photo.ID])
			return i;
	}
	return -1;
}

#pragma mark - CLASS
+ (StorageHelper *)sharedHelper {
	static StorageHelper *shared;
	if (!shared) {
		shared = [[StorageHelper alloc] init];
	}
	return shared;
}

@end
