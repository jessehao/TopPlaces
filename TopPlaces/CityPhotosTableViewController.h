//
//  CityPhotosTableViewController.h
//  Top Places
//
//  Created by 郝泽 on 2017/8/8.
//  Copyright © 2017年 JH. All rights reserved.
//

#import "FlickrPhotosTableViewController.h"

@class Place;

@interface CityPhotosTableViewController : FlickrPhotosTableViewController
@property (strong, nonatomic) Place *place;
@end
