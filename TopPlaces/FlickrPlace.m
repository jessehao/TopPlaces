//
//  FlickrPlace.m
//  TopPlaces
//
//  Created by 郝泽 on 2017/8/8.
//  Copyright © 2017年 JH. All rights reserved.
//

#import "FlickrPlace.h"
#import "FlickrFetcher.h"

@interface FlickrPlace()
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic, readwrite) NSString *country;
@property (strong, nonatomic, readwrite) NSString *province;
@property (strong, nonatomic, readwrite) NSString *city;
@end

@implementation FlickrPlace

@synthesize raw = _raw;

- (NSString *)ID {
	return [self.raw valueForKeyPath:FLICKR_PLACE_ID];
}

- (void)setContent:(NSString *)content {
	_content = content;
	NSArray<NSString *> * values = [content componentsSeparatedByString:@", "];
	if (values.count >= 2) {
		self.city = values.firstObject;
		if (values.count >= 3) {
			self.province = values[1];
		} else {
			self.province = nil;
		}
	} else {
		self.city = nil;
	}
	self.country = values.lastObject;
}

- (void)setRaw:(NSDictionary *)raw {
	_raw = raw;
	self.content = [raw valueForKeyPath:FLICKR_PLACE_NAME];
}

- (NSComparisonResult)compare:(FlickrPlace *)place {
	return [self.city compare:place.city];
}
@end
