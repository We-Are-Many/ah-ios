//
//  BUser.h
//  Bound
//
//  Created by Avikant Saini on 4/1/17.
//  Copyright © 2017 avikantz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BUser : NSObject

@property (nonatomic) NSString *uid;
@property (nonatomic) NSString *facebook_id;

@property (nonatomic) NSString *username;
@property (nonatomic) NSString *full_name;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *mobileno;
@property (nonatomic) NSString *profile_pic_url;

@property (nonatomic) NSArray <NSString *> *friends;

@property (nonatomic) NSString *help_needed;
@property (nonatomic) NSString *addiction;

@property (nonatomic) NSTimeInterval date_created_stamp;
@property (nonatomic) NSTimeInterval date_modified_stamp;

- (instancetype)initWithUserID:(NSString *)uid andDict:(id)dict;

- (void)setPropertiesFromDict:(id)dict;

+ (BUser *)sharedUser;

@end
