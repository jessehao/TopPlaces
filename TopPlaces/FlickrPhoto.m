//
//  FlickrPhoto.m
//  TopPlaces
//
//  Created by 郝泽 on 2017/8/8.
//  Copyright © 2017年 JH. All rights reserved.
//

#import "FlickrPhoto.h"
#import "FlickrFetcher.h"

@class FlickrPlace;

@interface FlickrPhoto ()
@property (strong, nonatomic, readwrite) FlickrPlace *place;
@end

@implementation FlickrPhoto

- (NSString *)title {
	return [self.raw valueForKeyPath:FLICKR_PHOTO_TITLE];
}

- (NSString *)descriptionContent {
	return [self.raw valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
}

- (NSString *)ID {
	return [self.raw valueForKeyPath:FLICKR_PHOTO_ID];
}

- (NSString *)owner {
	return [self.raw valueForKeyPath:FLICKR_PHOTO_OWNER];
}

- (NSDate *)uploadDate {
	NSString *string = [self.raw valueForKeyPath:FLICKR_PHOTO_UPLOAD_DATE];
	NSTimeInterval interval = string.doubleValue;
	return [NSDate dateWithTimeIntervalSince1970:interval];
}

- (NSURL *)url {
	return [FlickrFetcher URLforPhoto:self.raw format:FlickrPhotoFormatLarge];
}

@end
