//
//  DownloadHelper.h
//  TopPlaces
//
//  Created by 郝泽 on 2017/8/18.
//  Copyright © 2017年 JH. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadHelper : NSObject
- (void)startDownload;
- (void)startDownloadWaitTillFinished;
#pragma mark - CLASS
+ (DownloadHelper *)sharedHelper;
@end
