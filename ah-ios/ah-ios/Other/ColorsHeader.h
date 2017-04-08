//
//  ColorsHeader.h
//  ah-ios
//
//  Created by Avikant Saini on 4/8/17.
//  Copyright © 2017 avikantz. All rights reserved.
//

#ifndef ColorsHeader_h
#define ColorsHeader_h

#define UIColorFromRGBWithAlpha(rgbValue, a) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define COLOR_PRIMARY_RED	UIColorFromRGBWithAlpha(0xfc5454, 1.f)
#define COLOR_LIGHT_RED		UIColorFromRGBWithAlpha(0xe08283, 1.f)
#define COLOR_DARK_RED		UIColorFromRGBWithAlpha(0x96281b, 1.f)

#define COLOR_GRAY_1		UIColorFromRGBWithAlpha(0x93a6b8, 1.f)
#define COLOR_GRAY_2		UIColorFromRGBWithAlpha(0x8cd2db, 1.f)

#define COLOR_TEXT_COLOR_1	UIColorFromRGBWithAlpha(0x212121, 1.f)
#define COLOR_TEXT_COLOR_2	UIColorFromRGBWithAlpha(0x546e7a, 1.f)

#define COLOR_GREEN			UIColorFromRGBWithAlpha(0xdce775, 1.f)
#define COLOR_YELLOW		UIColorFromRGBWithAlpha(0xffee58, 1.f)
#define COLOR_SUCCESS		UIColorFromRGBWithAlpha(0x00a650, 1.f)
#define COLOR_FAILURE		UIColorFromRGBWithAlpha(0xe65100, 1.f)

#define GLOBAL_BACK_COLOR COLOR_LIGHT_BLUE

#endif /* ColorsHeader_h */
