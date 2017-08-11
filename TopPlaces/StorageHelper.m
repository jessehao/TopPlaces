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
@property (nonatomic, getter=isSynced) BOOL synced;
@property (strong, nonatomic) NSMutableArray<NSDictionary *> *recentRawPhotos;
@end

@implementation StorageHelper
@synthesize recentPhotos = _recentPhotos;

- (NSMutableArray<NSDictionary *> *)recentRawPhotos {
	if (!_recentRawPhotos) {
		_recentRawPhotos = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:STORAGE_RECENT_PHOTOS_KEY];
		if (!_recentRawPhotos) {
			_recentRawPhotos = [NSMutableArray array];
		}
	}
	return _recentRawPhotos;
}

- (NSMutableArray<FlickrPhoto *> *)recentPhotos {
	if (!_recentPhotos) {
		_recentPhotos = [NSMutableArray array];
	}
	if (!self.isSynced) {
		[_recentPhotos removeAllObjects];
		for (NSInteger i = self.recentRawPhotos.count - 1; i >= 0; i--) {
			FlickrPhoto *photo = [[FlickrPhoto alloc] initWithRaw:self.recentRawPhotos[i]];
			[_recentPhotos addObject:photo];
		}
		self.synced = YES;
	}
	return _recentPhotos;
}

#pragma mark - Initialization
- (instancetype)init {
	self = [super init];
	if (self) {
		self.changed = NO;
		self.synced = NO;
	}
	return self;
}

#pragma mark - Operations

- (void)addPhoto:(FlickrPhoto *)photo {
	NSInteger index = [self containsPhoto:photo];
	if (index == self.recentRawPhotos.count - 1) {
		return;
	}
	if (index > 0) {
		[self.recentRawPhotos removeObjectAtIndex:index];
	} else if (self.recentRawPhotos.count >= STORAGE_RECENT_PHOTOS_CAPACITY ) {
		[self.recentRawPhotos removeObjectAtIndex:0];
	}
	[self.recentRawPhotos addObject:photo.raw];
	self.changed = YES;
	self.synced = NO;
}

- (void)save {
	if (self.changed) {
		[[NSUserDefaults standardUserDefaults] setObject:self.recentRawPhotos forKey:STORAGE_RECENT_PHOTOS_KEY];
		self.changed = NO;
	}
}

- (NSInteger)containsPhoto:(FlickrPhoto *)photo {
	for (int i = 0; i<self.recentPhotos.count; i++) {
		if([self.recentPhotos[i].ID isEqualToString:photo.ID])
			return self.recentPhotos.count - 1 - i;
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
