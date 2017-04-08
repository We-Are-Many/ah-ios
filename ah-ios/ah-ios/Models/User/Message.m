//
//  Message.m
//  ah-ios
//
//  Created by Avikant Saini on 4/9/17.
//  Copyright © 2017 avikantz. All rights reserved.
//

#import "Message.h"

@implementation Message

- (instancetype)initWithTo:(NSString *)to from:(NSString *)from text:(NSString *)text {
	self = [super init];
	if (self) {
		self.to = to;
		self.from = from;
		self.text = text;
	}
	return self;
 }

+ (NSMutableArray<Message *> *)getMessagesFromSnapshot:(NSDictionary *)snapshot from:(NSString *)from andTo:(NSString *)to {
	NSMutableArray *messages = [NSMutableArray new];
	for (NSDictionary *dict in snapshot) {
		Message *m = [[Message alloc] initWithTo:[dict objectForKey:@"to"] from:[dict objectForKey:@"from"] text:[dict objectForKey:@"text"]];
		if (([m.to isEqualToString:to] && [m.from isEqualToString:from]) || ([m.to isEqualToString:from] && [m.from isEqualToString:to])) {
			[messages addObject:m];
		}
	}
	return messages;
}

@end
