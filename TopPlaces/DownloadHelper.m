//
//  DownloadHelper.m
//  TopPlaces
//
//  Created by 郝泽 on 2017/8/18.
//  Copyright © 2017年 JH. All rights reserved.
//
#import <CoreData/CoreData.h>
#import "DBAvailability.h"
#import "FlickrFetcher.h"
#import "DownloadHelper.h"
#import "DataHelper.h"
#import "Photo+Flickr.h"
#import "Place+Flickr.h"

#define BACKGROUND_SESSION_CONFIG_IDENTIFIER @"BackGroundSessionConfig"
#define DOWNLOAD_TASK_DESCRIPTION @"DownloadTaskDescription"

@interface DownloadHelper () <NSURLSessionDownloadDelegate>
@property (strong, nonatomic) NSURLSession *session;
@end

@implementation DownloadHelper
- (NSURLSession *)session {
	if (!_session) {
		static dispatch_once_t onceToken;
		dispatch_once(&onceToken, ^{
			NSURLSessionConfiguration *config = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:BACKGROUND_SESSION_CONFIG_IDENTIFIER];
			config.allowsCellularAccess = NO;
			_session = [NSURLSession sessionWithConfiguration:config
													 delegate:self
												delegateQueue:nil];
		});
	}
	return _session;
}

#pragma mark - Download Delegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)localFile {
	if ([downloadTask.taskDescription isEqualToString:DOWNLOAD_TASK_DESCRIPTION]) {
		NSManagedObjectContext *context = [[DataHelper sharedHelper] managedContext];
		if (context) {
			[context performBlock:^{
				[Photo loadPhotosFromURL:localFile inManagedObjectContext:context];
			}];
		}
	}
}

#pragma mark - Operations
- (void)startDownload {
	[self.session getTasksWithCompletionHandler:^(NSArray<NSURLSessionDataTask *> * _Nonnull dataTasks, NSArray<NSURLSessionUploadTask *> * _Nonnull uploadTasks, NSArray<NSURLSessionDownloadTask *> * _Nonnull downloadTasks) {
		if (![downloadTasks count]) {
			NSURLSessionDownloadTask *task = [self.session downloadTaskWithURL:[FlickrFetcher URLforRecentGeoreferencedPhotos]];
			task.taskDescription = DOWNLOAD_TASK_DESCRIPTION;
			[task resume];
		} else {
			for (NSURLSessionDownloadTask *task in downloadTasks) {
				[task resume];
			}
		}
	}];
}

- (void)startDownloadWaitTillFinished {
	[Photo loadPhotosFromURL:[FlickrFetcher URLforRecentGeoreferencedPhotos]
	  inManagedObjectContext:[[DataHelper sharedHelper] managedContext]];
}

#pragma mark - CLASS
+ (DownloadHelper *)sharedHelper {
	static DownloadHelper *shared;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		if (!shared) {
			shared = [[DownloadHelper alloc] init];
		}
	});
	return shared;
}
@end
