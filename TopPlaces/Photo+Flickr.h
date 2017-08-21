//
//  Photo+Flickr.h
//  TopPlaces
//
//  Created by 郝泽 on 2017/8/17.
//  Copyright © 2017年 JH. All rights reserved.
//

#import "Photo+CoreDataClass.h"

@interface Photo (Flickr)

+ (Photo *)photoWithRaw:(NSDictionary *)raw inManagedObjectContext:(NSManagedObjectContext *)context;
+ (Photo *)photoWithRaw:(NSDictionary *)raw alreadyExistedInManagedObjectContext:(NSManagedObjectContext *)context;
+ (Photo *)photoWithRaw:(NSDictionary *)raw insertIntoManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray<NSDictionary *> *)rawPhotosAtURL:(NSURL *)url;
+ (void)loadPhotosFromRawArray:(NSArray<NSDictionary *> *)rawPhotos inManagedObjectContext:(NSManagedObjectContext *)context;
+ (void)loadPhotosFromURL:(NSURL *)url inManagedObjectContext:(NSManagedObjectContext *)context;
@end
