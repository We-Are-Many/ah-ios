//
//  ConversationBaseTableViewCell.m
//  Video Player
//
//  Created by Avikant Saini on 5/31/16.
//  Copyright © 2016 Chekkoo. All rights reserved.
//

#import "ConversationBaseTableViewCell.h"

@interface ConversationBaseTableViewCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewBottomConstraint; // Initially 12
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewLeadingConstraint; // Initially 2
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewTrailingConstraint; // Initially 2
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *containerViewTopConstraint; // Initially 4 : No sender label

@property (weak, nonatomic) IBOutlet UILabel *senderLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *sentStatusImageView;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (nonatomic) BOOL hidesDateLabel;

@end

@implementation ConversationBaseTableViewCell {
	NSInteger leftOffset;
	NSInteger rightOffset;
}

- (void)awakeFromNib {
    [super awakeFromNib];
	
	leftOffset = 0;
	rightOffset = 0;
	
	self.estimatedWidth = VWIDTH - 8 - 80;
}

- (void)drawRect:(CGRect)rect {
	// Drawing borders
	[super drawRect:rect];
	CGRect boundingRect = CGRectMake(8 + leftOffset, 2, VWIDTH - 16 - rightOffset - leftOffset, VHEIGHT - 4);
	UIBezierPath *boundingPath = [UIBezierPath bezierPathWithRoundedRect:boundingRect cornerRadius:4];
	if (self.messageDirection == INCOMING) {
		[COLOR_LIGHT_GRAY setFill];
		if (!self.isCascading) {
			UIBezierPath *trianglePath = [UIBezierPath bezierPath];
			[trianglePath moveToPoint:CGPointMake(2, VHEIGHT - 2)];
			[trianglePath addLineToPoint:CGPointMake(8, VHEIGHT - 12)];
			[trianglePath addLineToPoint:CGPointMake(12, VHEIGHT - 4)];
			[trianglePath closePath];
			[trianglePath fill];
		}
	} else if (self.messageDirection == OUTGOING) {
		[COLOR_SKY_BLUE setFill];
		if (!self.isCascading) {
			UIBezierPath *trianglePath = [UIBezierPath bezierPath];
			[trianglePath moveToPoint:CGPointMake(VWIDTH - 2, VHEIGHT - 2)];
			[trianglePath addLineToPoint:CGPointMake(VWIDTH - 8, VHEIGHT - 12)];
			[trianglePath addLineToPoint:CGPointMake(VWIDTH - 12, VHEIGHT - 4)];
			[trianglePath closePath];
			[trianglePath fill];
		}
	} else {
		[UIColorFromRGBWithAlpha(0x336e7b, 1.f) setFill];
	}
	[boundingPath fill];
}

- (void)setMessageText:(NSString *)text {
	_messageLabel.text = text;
	self.estimatedWidth = [ConversationBaseTableViewCell getEstimatedWidthForText:text];
}

- (void)updateBoundaries {
	if (self.messageDirection == INCOMING) {
		rightOffset = MAX(78.0, VWIDTH - self.estimatedWidth - 10);
		leftOffset = 0;
		self.containerViewTrailingConstraint.constant = MAX(80.0, VWIDTH - self.estimatedWidth - 8);
		self.containerViewLeadingConstraint.constant = 2.0;
	}
	else if (self.messageDirection == OUTGOING) {
		rightOffset = 0;
		leftOffset = MAX(78.0, VWIDTH - self.estimatedWidth - 10);
		self.containerViewTrailingConstraint.constant = 2.0;
		self.containerViewLeadingConstraint.constant = MAX(VWIDTH - self.estimatedWidth - 8, 80.0);
	}
	else if (self.messageDirection == STATUS) {
		rightOffset = (VWIDTH - 8 - self.estimatedWidth)/2;
		leftOffset = (VWIDTH - 8 - self.estimatedWidth)/2;
		self.containerViewTrailingConstraint.constant = (VWIDTH - 8 - self.estimatedWidth)/2;
		self.containerViewLeadingConstraint.constant = (VWIDTH - 8 - self.estimatedWidth)/2;
	}
	[self setNeedsDisplay];
}

#pragma mark - Setters

- (void)setDate:(NSDate *)date {
	NSDateFormatter *formatter = [NSDateFormatter new];
	[formatter setDateFormat:@"hh:mm a"];
	self.dateLabel.text = [formatter stringFromDate:date];
}

- (void)setIsCascading:(BOOL)isCascading {
	_isCascading = isCascading;
	if (isCascading) {
		self.sentStatusImageView.transform = CGAffineTransformMakeTranslation(0, -2);
	}
	else {
		self.sentStatusImageView.transform = CGAffineTransformIdentity;
	}
}

- (void)setMessageDirection:(NSInteger)messageDirection {
	_messageDirection = messageDirection;
	// Relevant stuff
	[self setNeedsDisplay];
	if (messageDirection == INCOMING) {
		self.dateLabel.textAlignment = NSTextAlignmentLeft;
//		self.messageLabel.textAlignment = NSTextAlignmentLeft;
		self.messageLabel.textColor = [UIColor darkGrayColor];
		self.dateLabel.textColor = [UIColor lightGrayColor];
	} else if (messageDirection == OUTGOING) {
		self.dateLabel.textAlignment = NSTextAlignmentRight;
//		self.messageLabel.textAlignment = NSTextAlignmentRight;
		self.messageLabel.textColor = COLOR_WHITE;
		self.dateLabel.textColor = COLOR_WHITE;
	} else /*if (messageDirection == STATUS)*/ {
		self.dateLabel.textAlignment = NSTextAlignmentCenter;
//		self.messageLabel.textAlignment = NSTextAlignmentCenter;
		self.hidesDateLabel = YES; // Hide the date label for the status messages?
	}
	[self updateBoundaries];
}

- (void)setHidesDateLabel:(BOOL)hidesDateLabel {
	_hidesDateLabel = hidesDateLabel;
	if (hidesDateLabel) {
		self.containerViewBottomConstraint.constant = -4;
		self.dateLabel.hidden = YES;
	} else {
		self.containerViewBottomConstraint.constant = 12;
		self.dateLabel.hidden = NO;
	}
	[self layoutSubviews];
}

- (void)setEstimatedWidth:(NSInteger)estimatedWidth {
	NSInteger esw = 0;
	if (self.isMediaItem) {
		esw = VWIDTH - 8 - 80;
	} else {
		esw = MIN(MAX(estimatedWidth, 84 - (self.messageDirection == INCOMING) * 14), VWIDTH - 8 - 80);
	}
	_estimatedWidth = esw;
	[self updateBoundaries];
}

- (void)setSenderDisplayText:(NSString *)senderDisplayText {
	_senderDisplayText = senderDisplayText;
	if (senderDisplayText != nil && senderDisplayText.length > 0) {
		self.containerViewTopConstraint.constant = -14;
		self.senderLabel.text = senderDisplayText;
	} else {
		self.containerViewTopConstraint.constant = 4;
		self.senderLabel.text = @"";
	}
	[self layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

+ (NSInteger)getEstimatedWidthForText:(NSString *)text {
	CGRect rect = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, [self getEstimatedHeightForText:text]) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil];
	return rect.size.width + 28;
}

+ (NSInteger)getEstimatedWidthForText:(NSString *)text altText:(NSString *)text2 {
	CGRect rect = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, [self getEstimatedHeightForText:text]) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil];
	CGRect rect2 = [text2 boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, [self getEstimatedHeightForText:text2]) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12 weight:UIFontWeightMedium]} context:nil];
	return MAX(rect.size.width, rect2.size.width) + 28;
}

+ (NSInteger)getEstimatedHeightForText:(NSString *)text {
	CGRect rect = [text boundingRectWithSize:CGSizeMake(SWidth - 24 - 80, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} context:nil];
	return rect.size.height + 28;
}

@end
