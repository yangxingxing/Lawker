//
//  UserComm.m
//  lawker
//
//  Created by 杨星星 on 2017/3/3.
//  Copyright © 2017年 ShangxianDante. All rights reserved.
//

#import "UserComm.h"

//保存服务器端 IOS最大版本号
#define APPFirstDate @"APPFirstDate"
#import "NSDateCategory.h"

@implementation UserComm

+ (BOOL)showReleaseFunction {
    if (DEVELOPER_MODE) {
        return YES;
    }
    
    // https://itunes.apple.com/lookup?id=1190041374
    
    // app Version 版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    app_Version = [app_Version stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (app_Version.length==2) {
        app_Version  = [app_Version stringByAppendingString:@"0"];
    }else if (app_Version.length==1){
        app_Version  = [app_Version stringByAppendingString:@"00"];
    }
    
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSString *appStoreVersion = [userDefault valueForKey:AppStoreVerKey];
    // app Store Version
    appStoreVersion = [appStoreVersion stringByReplacingOccurrencesOfString:@"." withString:@""];
    if (appStoreVersion.length==2) {
        appStoreVersion  = [appStoreVersion stringByAppendingString:@"0"];
    }else if (appStoreVersion.length==1){
        appStoreVersion  = [appStoreVersion stringByAppendingString:@"00"];
    }
    
    // app build版本
    //    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
    
//        NSString *sVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleInfoDictionaryVersionKey];
//    NSString *sVerShort = APP_Ver_SHORT;
    
    
    NSString *firstDate = [userDefault objectForKey:APPFirstDate];
    if (!firstDate)
    {
        [userDefault setObject:[[NSDate date] dateTimeString] forKey:APPFirstDate];
        [userDefault synchronize];
    }
    
    BOOL oldUser = NO;
    if (firstDate && firstDate.length >= 8)
    {
        oldUser = [[NSDate dateFromString:firstDate] daysAgo] > 7;
    }
    
    
    return oldUser || (appStoreVersion && app_Version && appStoreVersion >= app_Version);
}

@end
