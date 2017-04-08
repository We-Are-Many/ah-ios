//
//  ConversationDetailViewController.h
//  Video Player
//
//  Created by Avikant Saini on 5/31/16.
//  Copyright © 2016 Chekkoo. All rights reserved.
//

#import "PeopleList.h"

#import <UIKit/UIKit.h>
#import <SlackTextViewController/SLKTextViewController.h>

@interface ConversationDetailViewController : SLKTextViewController

@property (nonatomic) PeopleList *person;

@end
