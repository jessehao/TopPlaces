//
//  DataHelper.h
//  TopPlaces
//
//  Created by 郝泽 on 2017/8/18.
//  Copyright © 2017年 JH. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const DATA_DOC_NAME = @"TopPlacesDoc";

@interface DataHelper : NSObject
@property (strong, nonatomic, readonly) NSManagedObjectContext *managedContext;
@property (strong, nonatomic, readonly) UIManagedDocument *managedDocument;
@property (strong, nonatomic, readonly) NSURL *fileURL;
+ (DataHelper *)sharedHelper;
@end
