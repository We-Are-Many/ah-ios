//
//  BUser.m
//  Bound
//
//  Created by Avikant Saini on 4/1/17.
//  Copyright © 2017 avikantz. All rights reserved.
//

#import "BUser.h"

@implementation BUser

- (instancetype)initWithUserID:(NSString *)uid andDict:(id)dict {
	self = [super init];
	if (self) {
		self.uid = [NSString stringWithFormat:@"%@", uid];
		[self setPropertiesFromDict:dict];
	}
	return self;
}

- (void)setPropertiesFromDict:(id)dict {
	@try {
		self.facebook_id = [dict objectForKey:@"facebook_id"];
		
		self.username = [dict objectForKey:@"username"];
		self.full_name = [dict objectForKey:@"full_name"];
		self.email = [dict objectForKey:@"email"];
		self.mobileno = [dict objectForKey:@"mobileno"];
		self.profile_pic_url = [dict objectForKey:@"profile_pic_url"];
		
		id friends_object = [dict objectForKey:@"friends"];
		if ([friends_object isKindOfClass:[NSDictionary class]]) {
			self.friends = [friends_object allKeys];
		}
		
		self.funds_gained = [[dict objectForKey:@"funds_gained"] doubleValue];
		self.score = [[dict objectForKey:@"score"] doubleValue];
		self.connections = [[dict objectForKey:@"connections"] integerValue];
		self.total_meetings = [[dict objectForKey:@"total_meetings"] integerValue];
		self.late_meetings = [[dict objectForKey:@"late_meetings"] integerValue];
		
		id meetings_object = [dict objectForKey:@"meetings_object"];
		if ([meetings_object isKindOfClass:[NSDictionary class]]) {
			self.meetings = [meetings_object allKeys];
		}
		
		self.settings = [dict objectForKey:@"settings"];
		
		self.date_created_stamp = [[dict objectForKey:@"date_created"] doubleValue];
		self.date_modified_stamp = [[dict objectForKey:@"date_modified"] doubleValue];
		
	} @catch (NSException *exception) {
		NSLog(@"Exception: %@", exception.reason);
	}
}

+ (BUser *)sharedUser {
	static BUser *user = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		user = [[BUser alloc] init];
	});
	return user;
}

@end
