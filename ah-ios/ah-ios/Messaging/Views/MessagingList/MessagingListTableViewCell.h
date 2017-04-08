//
//  MessagingListTableViewCell.h
//  Video Player
//
//  Created by Avikant Saini on 5/27/16.
//  Copyright © 2016 Chekkoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessagingListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *messagePreviewLabel;

@property (weak, nonatomic) IBOutlet UILabel *messageTimeStampLabel;

@property (weak, nonatomic) IBOutlet UIImageView *messageStatusImageView;

@property (weak, nonatomic) IBOutlet UILabel *unreadLabel;

@end
