//
//  Place+Flickr.h
//  TopPlaces
//
//  Created by 郝泽 on 2017/8/17.
//  Copyright © 2017年 JH. All rights reserved.
//

#import "Place+CoreDataClass.h"

@interface Place (Flickr)
+ (Place *)placeWithUnique:(NSString *)unique andPhotographer:(Photographer *)photographer inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Place *)placeWithUnique:(NSString *)unique alreadyExistedInManagedObjectContext:(NSManagedObjectContext *)context;
+ (Place *)placeWithUnique:(NSString *)unique insertIntoManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSDictionary *)rawWithUnique:(NSString *)unique;
@end
