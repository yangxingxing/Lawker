//
//  NSString+MD5.m
//  lawker
//
//  Created by ASW on 2016-12-9.
//  Copyright © 2016年 ShangxianDante. All rights reserved.
//

#import "NSString+MD5.h"

@implementation NSString (MD5)

+ (NSString *)md5To32bit:(NSString *)str {
    
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    //CC_MD5( cStr, strlen(cStr),digest );
    CC_MD5(cStr,(CC_LONG)strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [result appendFormat:@"%02x", digest[i]];
    return result;
}
@end
