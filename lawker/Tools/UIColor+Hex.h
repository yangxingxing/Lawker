//
//  UIColor+Hex.h
//  lawker
//
//  Created by 杨星星 on 2017/2/27.
//  Copyright © 2017年 ShangxianDante. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

//从十六进制字符串获取颜色，
//color:支持 0X123456
+ (UIColor *)colorWithHex:(int)rgbValue alpha:(CGFloat)alpha;

@end
