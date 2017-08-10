//
//  FlickrHelper.h
//  TopPlaces
//
//  Created by 郝泽 on 2017/8/8.
//  Copyright © 2017年 JH. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FlickrPlace;
@class FlickrPhoto;

@interface FlickrHelper : NSObject

@property (strong, nonatomic, readonly) NSMutableDictionary<NSString *, NSMutableArray<FlickrPlace *> *> *places;

- (void)refreshPlaces;
- (NSArray<FlickrPhoto *> *)photosFromPlace:(FlickrPlace *)place;

+ (FlickrHelper *)sharedHelper;
@end
