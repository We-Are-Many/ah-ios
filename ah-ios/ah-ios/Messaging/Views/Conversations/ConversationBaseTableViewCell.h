//
//  ConversationBaseTableViewCell.h
//  Video Player
//
//  Created by Avikant Saini on 5/31/16.
//  Copyright © 2016 Chekkoo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define INCOMING 11
#define OUTGOING 12
#define STATUS 13

@interface ConversationBaseTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (nonatomic) BOOL isCascading;
@property (nonatomic) BOOL isMediaItem;

@property (nonatomic) NSString *senderDisplayText; // nil or "" for nothing

@property (nonatomic) NSInteger estimatedWidth;

@property (nonatomic) NSInteger messageDirection;

- (void)setMessageText:(NSString *)text;

- (void)setDate:(NSDate *)date;

+ (NSInteger)getEstimatedHeightForText:(NSString *)text;

@end
