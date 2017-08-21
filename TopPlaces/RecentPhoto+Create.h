//
//  RecentPhoto+Create.h
//  TopPlaces
//
//  Created by 郝泽 on 2017/8/19.
//  Copyright © 2017年 JH. All rights reserved.
//

#import "RecentPhoto+CoreDataClass.h"

@class Photo;

@interface RecentPhoto (Create)
+ (RecentPhoto *)recentPhotoWithPhoto:(Photo *)photo inManagedObjectContext:(NSManagedObjectContext *)context;
+ (RecentPhoto *)recentPhotoWithPhoto:(Photo *)photo alreadyExistedInManagedObjectContext:(NSManagedObjectContext *)context;
+ (RecentPhoto *)recentPhotoWithPhoto:(Photo *)photo insertIntoManagedObjectContext:(NSManagedObjectContext *)context;
@end
