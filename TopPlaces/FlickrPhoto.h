//
//  FlickrPhoto.h
//  TopPlaces
//
//  Created by 郝泽 on 2017/8/8.
//  Copyright © 2017年 JH. All rights reserved.
//

#import "FlickrCommon.h"

@class FlickrPlace;

@interface FlickrPhoto : FlickrCommon

@property (strong, nonatomic, readonly) NSString *title;
@property (strong, nonatomic, readonly) NSString *descriptionContent;
@property (strong, nonatomic, readonly) NSString *owner;
@property (strong, nonatomic, readonly) NSDate *uploadDate;
@property (strong, nonatomic, readonly) FlickrPlace *place;
@property (strong, nonatomic, readonly) NSURL *url;

- (instancetype) initWithRaw:(NSDictionary *)raw andPlace:(FlickrPlace *)place;

@end
