//
//  ContactListTableViewCell.h
//  Video Player
//
//  Created by Avikant Saini on 5/27/16.
//  Copyright © 2016 Chekkoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *inviteButton;

/*
- (void)animateInviteButton;
- (void)hideInviteButton;
*/
 
@end
