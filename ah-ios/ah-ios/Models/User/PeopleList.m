//
//  PeopleList.m
//  ah-ios
//
//  Created by Avikant Saini on 4/9/17.
//  Copyright © 2017 avikantz. All rights reserved.
//

#import "PeopleList.h"

@implementation PeopleList

- (instancetype)initWithUID:(NSString *)uid andDict:(NSDictionary *)dict {
	self = [super init];
	if (self) {
		self.uid = uid;
		self.addiction = [dict objectForKey:@"addiction"];
		self.name = [self randomName];
		self.online = [[dict objectForKey:@"online"] boolValue];
	}
	return self;
}

+ (NSMutableArray<PeopleList *> *)getListFromSnapshot:(NSDictionary *)snapshot {
	NSMutableArray <PeopleList *> *list = [NSMutableArray new];
	for (NSString *key in snapshot.allKeys) {
		PeopleList *ppl = [[PeopleList alloc] initWithUID:key andDict:snapshot[key]];
		if (ppl.online && ![key isEqualToString:[BUser sharedUser].uid]) {
			[list addObject:ppl];
		}
	}
	return list;
}

- (NSString *)randomName {
	NSArray *strings = @[@"Rossie Mowen",
						 @"Cyndi Poulos",
						 @"Florida Varga",
						 @"Iesha Black",
						 @"Beaulah Ceniceros",
						 @"Jutta Compos",
						 @"Luella Zynda",
						 @"Ronni Yuen",
						 @"Lorean Damiano",
						 @"Sharice Polley",
						 @"Colene Mcallister",
						 @"Farrah Kimberling",
						 @"Lyndia Anders",
						 @"Jeanelle Nowland",
						 @"Catherin Sosebee",
						 @"Keshia Holdaway",
						 @"Galen Midgley",
						 @"Antony Goldberg",
						 @"Annette Leitzel",
						 @"Luba Daubert",
						 @"Shaun Petti",
						 @"Buford Dorsey",
						 @"Lianne Cape",
						 @"Blanche Golder",
						 @"Renata Brim",
						 @"Luciana Cheesman",
						 @"Hye Kilbourne",
						 @"Rosalinda Tan",
						 @"Valeri Giberson",
						 @"Malisa Nishioka"];
	NSInteger index = arc4random_uniform((int)strings.count);
	return [strings objectAtIndex:index];
}

@end
