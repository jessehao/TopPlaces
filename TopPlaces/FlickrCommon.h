//
//  FlickrCommon.h
//  TopPlaces
//
//  Created by 郝泽 on 2017/8/8.
//  Copyright © 2017年 JH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrCommon : NSObject

@property (strong, nonatomic) NSDictionary *raw;
@property (strong, nonatomic, readonly) NSString *ID;
@property (nonatomic,readonly) double latitude;
@property (nonatomic, readonly) double longtitude;

- (instancetype)initWithRaw:(NSDictionary *)raw;

@end
