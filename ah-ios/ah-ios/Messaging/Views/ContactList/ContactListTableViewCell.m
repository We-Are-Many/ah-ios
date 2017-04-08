//
//  ContactListTableViewCell.m
//  Video Player
//
//  Created by Avikant Saini on 5/27/16.
//  Copyright © 2016 Chekkoo. All rights reserved.
//

#import "ContactListTableViewCell.h"

@interface ContactListTableViewCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inviteButtonWidthConstraint;

@property (weak, nonatomic) IBOutlet UILabel *adminLabel;


@end

@implementation ContactListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
	self.inviteButton.backgroundColor = COLOR_PRIMARY_RED;
}


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
	[super setHighlighted:highlighted animated:animated];
	self.inviteButton.backgroundColor = COLOR_PRIMARY_RED;
}

// Huh, this is bad.
/*
- (void)animateInviteButton {
	[self layoutIfNeeded];
	UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[self.inviteButton setTitle:@"" forState:UIControlStateNormal];
	self.inviteButtonWidthConstraint.constant = self.inviteButton.bounds.size.height;
	[spinner startAnimating];
	[UIView animateWithDuration:0.3 animations:^{
		[self layoutIfNeeded];
	} completion:^(BOOL finished) {
		[self.inviteButton addSubview:spinner];
		spinner.bounds = self.inviteButton.frame;
		spinner.translatesAutoresizingMaskIntoConstraints = YES;
	}];
}

- (void)hideInviteButton {
	[self layoutIfNeeded];
	[self.inviteButton.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
	self.inviteButtonWidthConstraint.constant = 120;
	[UIView animateWithDuration:0.3 animations:^{
		[self layoutIfNeeded];
	} completion:^(BOOL finished) {
		[self.inviteButton setTitle:@"INVITED" forState:UIControlStateNormal];
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
			self.inviteButton.hidden = YES;
		});
	}];
}
 */


@end
