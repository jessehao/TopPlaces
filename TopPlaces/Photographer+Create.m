//
//  Photographer+Create.m
//  TopPlaces
//
//  Created by 郝泽 on 2017/8/17.
//  Copyright © 2017年 JH. All rights reserved.
//

#import "Photographer+Create.h"
#import "Photo+CoreDataClass.h"

@implementation Photographer (Create)
+ (Photographer *)photographerWithName:(NSString *)name inManagedObjectContext:(NSManagedObjectContext *)context {
	if (![self isValidName:name andContext:context]) {
		return nil;
	}
	Photographer *photographer = [self photographerWithName:name alreadyExistInManagedObjectContext:context];
	if (!photographer) {
		photographer = [self photographerWithName:name insertIntoManagedObjectContext:context];
	}
	return photographer;
}

+ (Photographer *)photographerWithName:(NSString *)name alreadyExistInManagedObjectContext:(NSManagedObjectContext *)context {
	if (![self isValidName:name andContext:context]) {
		return nil;
	}
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:Photographer.entity.name];
	request.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
	NSError *error;
	NSArray *matches = [context executeFetchRequest:request error:&error];
	if (!matches || error) {
		NSLog(@"[%@ %@] executing fetch request error", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
		return nil;
	}
	if (matches.count > 1) {
		NSLog(@"[%@ %@] too many Photographer with ONE name (unique name assumed)", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
	}
	return matches.firstObject;
}

+ (Photographer *)photographerWithName:(NSString *)name insertIntoManagedObjectContext:(NSManagedObjectContext *)context {
	if (![self isValidName:name andContext:context]) {
		return nil;
	}
	Photographer *result = [NSEntityDescription insertNewObjectForEntityForName:Photographer.entity.name
														 inManagedObjectContext:context];
	result.name = name;
	return result;
}

+ (BOOL)isValidName:(NSString *)name andContext:(NSManagedObjectContext *)context {
	if (!context) {
		NSLog(@"[%@ %@] no context", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
		return NO;
	}
	if (![name length]) {
		NSLog(@"[%@ %@] no name", NSStringFromClass([self class]), NSStringFromSelector(_cmd));
		return NO;
	}
	return YES;
}
@end
