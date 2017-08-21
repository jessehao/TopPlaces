//
//  Photographer+Create.h
//  TopPlaces
//
//  Created by 郝泽 on 2017/8/17.
//  Copyright © 2017年 JH. All rights reserved.
//

#import "Photographer+CoreDataClass.h"

@interface Photographer (Create)
+ (Photographer *)photographerWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Photographer *)photographerWithName:(NSString *)name alreadyExistInManagedObjectContext:(NSManagedObjectContext *)context;
+ (Photographer *)photographerWithName:(NSString *)name insertIntoManagedObjectContext:(NSManagedObjectContext *)context;
@end
