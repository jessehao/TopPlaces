//
//  FlickrPlace.h
//  TopPlaces
//
//  Created by 郝泽 on 2017/8/8.
//  Copyright © 2017年 JH. All rights reserved.
//

#import "FlickrCommon.h"

@interface FlickrPlace : FlickrCommon
@property (strong, nonatomic, readonly) NSString *country;
@property (strong, nonatomic, readonly) NSString *province;
@property (strong, nonatomic, readonly) NSString *city;

@end
