//
//  StorageUtilities.h
//  TopPlaces
//
//  Created by 郝泽 on 2017/8/8.
//  Copyright © 2017年 JH. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FlickrPhoto;

static NSString *const STORAGE_RECENT_PHOTOS_KEY = @"RecentPhotos";
static NSUInteger STORAGE_RECENT_PHOTOS_CAPACITY = 20;

@interface StorageHelper : NSObject

@property (strong, nonatomic, readonly) NSMutableArray<FlickrPhoto *> *recentPhotos;
@property (nonatomic, readonly, getter=isChanged) BOOL changed;

- (void)addPhoto:(FlickrPhoto *)photo;
- (void)save;

#pragma mark - CLASS
+ (StorageHelper *)sharedHelper;
@end
