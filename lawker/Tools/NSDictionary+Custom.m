//
//  NSDictionary+Custom.m
//  wBaiJu
//
//  Created by fengshen on 15/11/21.
//  Copyright © 2015年 fengshen. All rights reserved.
//

#import "NSDictionary+Custom.h"

@implementation NSDictionary (Custom)

-(NSString*)valueForKeyCustom:(NSString *)key{
    NSString * value = [self valueForKey:key];
    if (value && [value isKindOfClass:[NSString class]] && value.length > 0) {
        return value;
    }else if (value && [value isKindOfClass:[NSNumber class]]){
        return value.description;
    }else{
        return @"";
    }
}

-(void)setString:(NSString *)value forKey:(NSString *)key{
    if (value && value.length > 0) {
        [self setValue:value forKey:key];
    }
}

@end
