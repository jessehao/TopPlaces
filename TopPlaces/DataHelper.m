//
//  DataHelper.m
//  TopPlaces
//
//  Created by 郝泽 on 2017/8/18.
//  Copyright © 2017年 JH. All rights reserved.
//

#import "DataHelper.h"
#import "DBAvailability.h"
@interface DataHelper ()
@property (strong, nonatomic) UIManagedDocument *managedDocument;
@property (strong, nonatomic) NSURL *fileURL;
@property (strong, nonatomic) NSManagedObjectContext *managedContext;
@end

@implementation DataHelper

- (NSURL *)fileURL {
	if (!_fileURL) {
		_fileURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory
														  inDomains:NSUserDomainMask] firstObject];
		_fileURL = [_fileURL URLByAppendingPathComponent:DATA_DOC_NAME];
	}
	return _fileURL;
}

- (UIManagedDocument *)managedDocument {
	if (!_managedDocument) {
		_managedDocument = [[UIManagedDocument alloc] initWithFileURL:self.fileURL];
	}
	return _managedDocument;
}

- (void)setManagedContext:(NSManagedObjectContext *)managedContext {
	_managedContext = managedContext;
	NSDictionary *userInfo = self.managedContext ? @{ DBA_USERINFO_CONTEXT : self.managedContext } : nil;
	[[NSNotificationCenter defaultCenter] postNotificationName:DBA_NOTIFICATION_CONTEXT_SET
														object:self
													  userInfo:userInfo];
}

#pragma mark - Initialization
- (void)setup {
	if ([[NSFileManager defaultManager] fileExistsAtPath:self.fileURL.path]) {
		[self.managedDocument openWithCompletionHandler:^(BOOL success) {
			if (success) {
				[self documentIsReady];
			} else {
				NSLog(@"couldn't open document at %@", self.fileURL);
			}
		}];
	} else {
		[self.managedDocument saveToURL:self.fileURL
					   forSaveOperation:UIDocumentSaveForCreating
					  completionHandler:^(BOOL success) {
						  if (success) {
							  [self documentIsReady];
						  } else {
							  NSLog(@"couldn't create document at %@", self.fileURL);
						  }
					  }];
	}
}

- (void)documentIsReady {
	if (self.managedDocument.documentState == UIDocumentStateNormal) {
		self.managedContext = self.managedDocument.managedObjectContext;
	}
}

#pragma mark - CLASS
+ (DataHelper *)sharedHelper {
	static DataHelper *shared;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		if (!shared) {
			shared = [[DataHelper alloc] init];
			[shared setup];
		}
	});
	return shared;
}
@end
