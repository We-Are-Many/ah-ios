//
//  TimeReusableHeaderFooterView.m
//  VideoPlayer
//
//  Created by Avikant Saini on 6/29/16.
//  Copyright © 2016 Chekkoo. All rights reserved.
//

#import "TimeReusableHeaderFooterView.h"

@interface TimeReusableHeaderFooterView ()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateLabelWidthConstraint;

@end

@implementation TimeReusableHeaderFooterView

- (void)awakeFromNib {
	self.backgroundView = ({
		UIView * view = [[UIView alloc] initWithFrame:self.bounds];
		view.backgroundColor = [UIColor clearColor];
		view;
	});
}

- (void)setDateText:(NSString *)dateText {
	_dateText = dateText;
	self.dateLabel.text = dateText;
	CGRect rect = [dateText boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 24) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.dateLabel.font} context:nil];
	self.dateLabelWidthConstraint.constant = rect.size.width + 16;
	[self layoutSubviews];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.dateLabel.layer.cornerRadius = 4;
	UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.dateLabel.frame];
	self.layer.shadowPath = shadowPath.CGPath;
	self.layer.shadowColor = UIColor.blackColor.CGColor;
	self.layer.shadowOffset = CGSizeZero;
	self.layer.shadowRadius = 2;
	self.layer.shadowOpacity = 0.6;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
