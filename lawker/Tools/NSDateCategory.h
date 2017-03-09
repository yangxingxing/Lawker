//
//  NSDate+NSDate_category.h
//  wBaiJu
//
//  Created by 家楗 邱 on 14-06-18.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "wConsts.h"

#import <Foundation/Foundation.h>


@interface NSDate (NSDateCategory)

//日期时间 格式 "yyyy-MM-dd HH:mm:ss"
+(NSDateFormatter *)dateTimeFormatter;

//日期    格式 "yyyy-MM-dd"
+(NSDateFormatter *)dateFormatter;

//时间    格式 "HH:mm:ss"  24小时制
+(NSDateFormatter *)timeFormater;

//服务端时间戳 转 NSTimeInterval timeInterval / 1000.0
+(NSTimeInterval)timeIntervalWithSvrTimeInterval:(long long)timeInterval;

//服务端时间戳 转 NSDate*        timeInterval / 1000.0
+(NSDate*)dateWithSvrTimeInterval:(long long)timeInterval;

//反回只有日期，没有带时间的 时间戳 timeInterval 为 服务端时间戳 / 1000.0 后
//本地时间戳， 不是基准
+(NSTimeInterval)dateOnlyWithSvrTimeInterval:(long long)timeInterval;

//反回只有日期，没有带时间的 时间戳
//是基准时间戳
+(NSTimeInterval)dateOnlyWithTimeInterval:(NSTimeInterval)timeInterval;

//获取年月日如:19871127.
- (NSString*)intDate;

//反回日期，去除时间. 如：2015-01-01 08:00:00 转为 2015-01-01
- (NSDate*)dateOnly;

//返回当前月一共有几周(可能为4,5,6)
- (int)getWeekNumOfMonth;

//该日期是该年的第几周
- (int)getWeekOfYear;

//返回day天后的日期(若day为负数,则为|day|天前的日期)
- (NSDate *)dateAfterDay:(NSInteger)day;

//计算两个日期之间的天数
- (NSInteger)daysFromDate:(NSDate *)date;

//month个月后的日期
- (NSDate *)dateafterMonth:(NSInteger)month;

//获取日
- (int)getDay;

//获取月
- (int)getMonth;

//获取年
- (int)getYear;

//获取小时
- (int)getHour;

//获取分钟
- (int)getMinute;

//返回一周的第几天(周末为第一天0)
- (int)weekDay;

//全写星期几 如：星期日 Sunday
- (NSString*)weekDayStr;

//转为NSString类型的
+(NSDate *)dateFromString:(NSString *)string;

+(NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;

+(NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed;

+(NSString *)stringForDisplayFromDate:(NSDate *)date;

- (NSString *)stringWithFormat:(NSString *)format;

//转为 "yyyy-MM-dd HH:mm:ss" 格式的字符串
- (NSString*)string;
- (NSString*)dateTimeString;  //与string相同

//转为 "yyyy-MM-dd"          格式的字符串
- (NSString*)dateString;

//转为 "HH:mm:ss"  格式
- (NSString*)timeString;

- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;

//- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;

//返回前天的年月日
- (NSDate *)beginningOfDay;

//返回该月的第一天
- (NSDate *)beginningOfMonth;

//该月的最后一天
- (NSDate *)endOfMonth;

//返回当前周的周末
- (NSDate *)endOfWeek;

//在当前日期前几天
- (NSInteger)daysAgo;

- (NSString *)stringDaysAgo;

- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag;

//显示 中文 日期时间 symbol 为True 时,显示 上午 下午 晚上 12小时制 showMinute < 59分钟时，显示XX分钟前
- (NSString*)stringDaysCNWithTime:(BOOL)showTime Symbol:(BOOL)symbol showMinute:(BOOL)showMinute;

@end
