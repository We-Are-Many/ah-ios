//
//  BBTableViewController.m
//  ah-ios
//
//  Created by Avikant Saini on 4/8/17.
//  Copyright © 2017 avikantz. All rights reserved.
//
#import "BBTableViewController.h"

@interface BBTableViewController ()

@end

@implementation BBTableViewController

- (void)viewDidLoad {
	
	[super viewDidLoad];
	
	self.shared_user = [BUser sharedUser];
	self.ref = [[FIRDatabase database] reference];
	
	self.transistion = [KWTransition manager];
	self.transistion.style = KWTransitionStyleFadeBackOver;
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - View controller animated transistioning

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented
																   presentingController:(UIViewController *)presenting
																	   sourceController:(UIViewController *)source {
	self.transistion.action = KWTransitionStepPresent;
	return self.transistion;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
	self.transistion.action = KWTransitionStepDismiss;
	return self.transistion;
}

@end
