//
//  NSString+MD5.h
//  lawker
//
//  Created by ASW on 2016-12-9.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (MD5)
+ (NSString *)md5To32bit:(NSString *)str;
@end
