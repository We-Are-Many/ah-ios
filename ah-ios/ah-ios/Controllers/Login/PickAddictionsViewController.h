//
//  PickAddictionsViewController.h
//  ah-ios
//
//  Created by Avikant Saini on 4/8/17.
//  Copyright © 2017 avikantz. All rights reserved.
//

#import "BBViewController.h"

@class PickAddictionsViewController;

@protocol AddictionPickingDelegate <NSObject>

- (void)pickAddictionsViewController:(PickAddictionsViewController *)controller didFinishPickingAddictions:(NSArray<NSString *> *)addictions;

@end

@interface PickAddictionsViewController : BBViewController

@property (nonatomic) id<AddictionPickingDelegate> delegate;

@end
