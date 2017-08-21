//
//  FlickrPhotosTableViewController.h
//  Top Places
//
//  Created by 郝泽 on 2017/8/8.
//  Copyright © 2017年 JH. All rights reserved.
//

#import "CoreDataTableViewController.h"

static NSString *const FLICKR_PHOTOS_CELL_IDENTIFIER = @"FlickrPhotosCell";
static NSString *const FLICKR_PHOTOS_TO_IMAGE_VIEW_SEGUE_IDENTIFIER = @"ToImageViewSegue";

@interface FlickrPhotosTableViewController : CoreDataTableViewController

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
