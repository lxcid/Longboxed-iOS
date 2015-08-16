//
//  UIColor+customColors.m
//  Longboxed-iOS
//
//  Created by johnrhickey on 8/4/14.
//  Copyright (c) 2014 Longboxed. All rights reserved.
//

#import "UIColor+LBXCustomColors.h"

@implementation UIColor (LBXCustomColors)

+ (UIColor *)LBXGreenColor {
    return [UIColor colorWithRed:92/255.0 green:184/255.0 blue:92/255.0 alpha:1.0];
}

+ (UIColor *)LBXBlueColor {
    return [UIColor colorWithRed:29/255.0 green:98/255.0 blue:240/255.0 alpha:1.0];
}

+ (UIColor *)LBXGrayColor {
    return [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:0.9];
}

+ (UIColor *)LBXRedColor {
    return [UIColor colorWithRed:251/255.0 green:59/255.0 blue:65/255.0 alpha:1.0];
}

+ (UIColor *)LBXGrayNavigationBarColor {
    return [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1.0];
}

+ (UIColor *)LBXVeryLightGrayColor {
    return [UIColor colorWithRed:224/255.0 green:225/255.0 blue:226/255.0 alpha:1.0];
}

+ (UIColor *)colorWithHex:(NSString *)hexString
{
    int red, green, blue;
    sscanf([hexString UTF8String], "#%2X%2X%2X", &red, &green, &blue);
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
}

@end
