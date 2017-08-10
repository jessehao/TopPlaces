//
//  FlickrCommon.m
//  TopPlaces
//
//  Created by 郝泽 on 2017/8/8.
//  Copyright © 2017年 JH. All rights reserved.
//

#import "FlickrCommon.h"
#import "FlickrFetcher.h"

@interface FlickrCommon()
@end

@implementation FlickrCommon

- (double)latitude {
	NSString *value = [self.raw valueForKey:FLICKR_LATITUDE];
	return value.doubleValue;
}

- (double)longtitude {
	NSString *value = [self.raw valueForKey:FLICKR_LONGITUDE];
	return value.doubleValue;
}

-(instancetype)initWithRaw:(NSDictionary *)raw {
	self = [self init];
	if (self) {
		self.raw = raw;
	}
	return self;
}

@end
