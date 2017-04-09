//
//  BBTableViewController.h
//  ah-ios
//
//  Created by Avikant Saini on 4/8/17.
//  Copyright © 2017 avikantz. All rights reserved.
//
@import Firebase;
@import FirebaseDatabase;

#import <UIKit/UIKit.h>
#import <KWTransition/KWTransition.h>
#import <AFNetworking/AFNetworking.h>

@interface BBTableViewController : UITableViewController <UIViewControllerTransitioningDelegate>

@property (nonatomic) BUser *shared_user;
@property (nonatomic) KWTransition *transistion;

@property (nonatomic) AFURLSessionManager *manager;

@property (nonatomic) FIRDatabaseReference *ref;

@end
