//
//  BBViewController.h
//  ah-ios
//
//  Created by Avikant Saini on 4/8/17.
//  Copyright © 2017 avikantz. All rights reserved.
//

@import Firebase;
@import FirebaseDatabase;

#import <AFNetworking/AFNetworking.h>
#import <UIKit/UIKit.h>
#import <KWTransition/KWTransition.h>

@interface BBViewController : UIViewController <UIViewControllerTransitioningDelegate>

@property (nonatomic) BUser *shared_user;
@property (nonatomic) KWTransition *transistion;

@property (nonatomic) AFURLSessionManager *manager;

@property (nonatomic) FIRDatabaseReference *ref;

@end
