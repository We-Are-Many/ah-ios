//
//  Message.h
//  ah-ios
//
//  Created by Avikant Saini on 4/9/17.
//  Copyright © 2017 avikantz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property (nonatomic) NSString *to;
@property (nonatomic) NSString *from;
@property (nonatomic) NSString *text;
@property (nonatomic) NSString *time_stamp;

- (instancetype)initWithTo:(NSString *)to from:(NSString *)from text:(NSString *)text;

+ (NSMutableArray <Message *> *)getMessagesFromSnapshot:(NSDictionary *)snapshot from:(NSString *)from andTo:(NSString *)to;

@end
