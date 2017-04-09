//
//  PeopleList.h
//  ah-ios
//
//  Created by Avikant Saini on 4/9/17.
//  Copyright © 2017 avikantz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PeopleList : NSObject

@property (nonatomic) NSString *uid;
@property (nonatomic) NSString *addiction;
@property (nonatomic) NSString *name;
@property (nonatomic) BOOL online;

- (instancetype)initWithUID:(NSString *)uid andDict:(NSDictionary *)dict;

- (NSString *)randomName;

+ (NSMutableArray <PeopleList *> *)getListFromSnapshot:(NSDictionary *)snapshot;

@end
