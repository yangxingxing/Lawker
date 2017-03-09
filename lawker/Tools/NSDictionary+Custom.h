//
//  NSDictionary+Custom.h
//  wBaiJu
//
//  Created by fengshen on 15/11/21.
//  Copyright © 2015年 fengshen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Custom)

-(NSString*)valueForKeyCustom:(NSString *)key;

-(void)setString:(NSString *)value forKey:(NSString *)key;

@end
