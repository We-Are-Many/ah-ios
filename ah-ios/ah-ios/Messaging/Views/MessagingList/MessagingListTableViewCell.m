//
//  MessagingListTableViewCell.m
//  Video Player
//
//  Created by Avikant Saini on 5/27/16.
//  Copyright © 2016 Chekkoo. All rights reserved.
//

#import "MessagingListTableViewCell.h"

@implementation MessagingListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
	self.messageStatusImageView.image = nil;
	self.messagePreviewLabel.transform = CGAffineTransformMakeTranslation(-24, 0);
	self.unreadLabel.layer.cornerRadius = 10.0;
	self.unreadLabel.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
