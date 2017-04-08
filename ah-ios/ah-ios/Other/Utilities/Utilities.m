//
//  Utilities.m
//  Bound
//
//  Created by Avikant Saini on 4/2/17.
//  Copyright © 2017 avikantz. All rights reserved.
//

#import "Utilities.h"

@implementation NSDate (DateUtils)

+ (NSTimeInterval)unixTimeStamp {
	return ([NSDate timeIntervalSinceReferenceDate] + NSTimeIntervalSince1970);
}

@end
