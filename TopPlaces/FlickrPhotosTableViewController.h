//
//  FlickrPhotosTableViewController.h
//  Top Places
//
//  Created by 郝泽 on 2017/8/8.
//  Copyright © 2017年 JH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlickrHelper;
@class FlickrPhoto;
@class StorageHelper;

static NSString *const FLICKR_PHOTOS_CELL_IDENTIFIER = @"FlickrPhotosCell";
static NSString *const FLICKR_PHOTOS_TO_IMAGE_VIEW_SEGUE_IDENTIFIER = @"ToImageViewSegue";

@interface FlickrPhotosTableViewController : UITableViewController

@property (strong, nonatomic) NSArray<FlickrPhoto *> *photos;
@property (strong, nonatomic, readonly) FlickrHelper *helper;
@property (strong, nonatomic, readonly) StorageHelper *storage;

#pragma mark - Abstract
- (IBAction)fetchPhotos;

@end
