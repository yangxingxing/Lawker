//
//  NSDate+NSDate_category.m
//  DishOrder iPad
//
//  Created by 家楗 邱 on 13-1-1.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "NSDateCategory.h"
/*
 G: 公元时代，例如AD公元
 yy: 年的后2位
 yyyy: 完整年
 MM: 月，显示为1-12
 MMM: 月，显示为英文月份简写,如 Jan
 MMMM: 月，显示为英文月份全称，如 Janualy
 dd: 日，2位数表示，如02
 d: 日，1-2位显示，如 2
 EEE: 简写星期几，如Sun
 EEEE: 全写星期几，如Sunday
 aa: 上下午，AM/PM
 H: 时，24小时制，0-23
 K：时，12小时制，0-11
 m: 分，1-2位
 mm: 分，2位
 s: 秒，1-2位
 ss: 秒，2位
 S: 毫秒
*/

static NSDateFormatter *sqliteDateTimeFormatter = nil;
static NSDateFormatter *sqliteDateFormatter = nil;
static NSDateFormatter *sqliteTimeFormatter = nil;

static NSDateFormatter *longWeekFormatter;   //星期几 全写EEEE: 全写星期几，如Sunday
//EEE: 简写星期几，如Sun


//中文 月 日格式  11月20日
static NSDateFormatter *gCnMonthDayFormatter = nil;
static NSDateFormatter *gCnYearMonthDayFormatter = nil;

#define ScnMonthDayFormat      @"MM月dd日"
#define ScnYearMonthDayFormat  @"YYYY年MM月dd日"

//中文 小时分种 格式 11:20
static NSDateFormatter *gCnShortHourMinuteFormatter = nil;
#define SCnShortHourMinuteFormat @"hh:mm"

//中文 小时分种 格式 11:20 24 小时制
static NSDateFormatter *gCnLongtHourMinuteFormatter = nil;
#define SCnLongHourMinuteFormat @"HH:mm"

@implementation NSDate (NSDateCategory)


+(NSDateFormatter *)dateTimeFormatter
{
    if (!sqliteDateTimeFormatter)
    {
        sqliteDateTimeFormatter = [[NSDateFormatter alloc] init];
        NSTimeZone *zone = [NSTimeZone localTimeZone];
        [sqliteDateTimeFormatter setTimeZone:zone];
        [sqliteDateTimeFormatter setDateFormat: SSQLDateTimeFormat];
    }
    return sqliteDateTimeFormatter;
}

+(NSDateFormatter *)dateFormatter
{
    if (!sqliteDateFormatter)
    {
        sqliteDateFormatter = [[NSDateFormatter alloc] init];
        NSTimeZone *zone = [NSTimeZone localTimeZone];
        [sqliteDateFormatter setTimeZone:zone];
        [sqliteDateFormatter setDateFormat: SSQLDateFormat];
    }
    return sqliteDateFormatter;
}

+(NSDateFormatter *)timeFormater
{
    if (!sqliteTimeFormatter)
    {
        sqliteTimeFormatter = [[NSDateFormatter alloc] init];
        NSTimeZone *zone = [NSTimeZone localTimeZone];
        [sqliteTimeFormatter setTimeZone:zone];
        [sqliteTimeFormatter setDateFormat: SSQLTimeFormat];
    }
    return sqliteTimeFormatter;
}

//中文 月 日格式  11月20日
+(NSDateFormatter *)cnMonthDayFormatter
{
    if (!gCnMonthDayFormatter)
    {
        gCnMonthDayFormatter = [[NSDateFormatter alloc] init];
        NSTimeZone *zone = [NSTimeZone localTimeZone];
        [gCnMonthDayFormatter setTimeZone:zone];
        [gCnMonthDayFormatter setDateFormat: ScnMonthDayFormat];
    }
    return gCnMonthDayFormatter;
}

//中文 月 日格式  2014年11月20日
+(NSDateFormatter *)cnYearMonthDayFormatter
{
    if (!gCnYearMonthDayFormatter)
    {
        gCnYearMonthDayFormatter = [[NSDateFormatter alloc] init];
        NSTimeZone *zone = [NSTimeZone localTimeZone];
        [gCnYearMonthDayFormatter setTimeZone:zone];
        [gCnYearMonthDayFormatter setDateFormat: ScnYearMonthDayFormat];
    }
    return gCnYearMonthDayFormatter;
}

//中文 小时分种 格式 11:20
+(NSDateFormatter *)cnShortHourMinuteFormatter
{
    if (!gCnShortHourMinuteFormatter)
    {
        gCnShortHourMinuteFormatter = [[NSDateFormatter alloc] init];
        NSTimeZone *zone = [NSTimeZone localTimeZone];  //
        [gCnShortHourMinuteFormatter setTimeZone:zone];
        [gCnShortHourMinuteFormatter setDateFormat: SCnShortHourMinuteFormat];
    }
    return gCnShortHourMinuteFormatter;
}

+(NSDateFormatter *)cnLongHourMinuteFormatter
{
    if (!gCnLongtHourMinuteFormatter)
    {
        gCnLongtHourMinuteFormatter = [[NSDateFormatter alloc] init];
        NSTimeZone *zone = [NSTimeZone localTimeZone];
        [gCnLongtHourMinuteFormatter setTimeZone:zone];
        [gCnLongtHourMinuteFormatter setDateFormat: SCnLongHourMinuteFormat];
    }
    return gCnLongtHourMinuteFormatter;
}

+(NSDateFormatter*)longWeekFormatter
{
    if (!longWeekFormatter)
    {
        longWeekFormatter = [[NSDateFormatter alloc] init];
        NSTimeZone *zone = [NSTimeZone localTimeZone];
        [longWeekFormatter setTimeZone:zone];
        [longWeekFormatter setDateFormat: @"EEEE"];
    }
    return longWeekFormatter;
}

//服务端时间戳 转NSTimeInterval timeInterval / 1000.0
+(NSTimeInterval)timeIntervalWithSvrTimeInterval:(long long)timeInterval
{
    return timeInterval / 1000.0;
}

//服务端时间戳 转NSDate timeInterval / 1000.0
+(NSDate*)dateWithSvrTimeInterval:(long long)timeInterval
{
    NSTimeInterval secs = [self timeIntervalWithSvrTimeInterval:timeInterval];
    return [NSDate dateWithTimeIntervalSince1970:secs];
}

//反回只有日期，没有带时间的 时间戳 timeInterval 为 服务端时间戳 / 1000.0 后
+(NSTimeInterval)dateOnlyWithSvrTimeInterval:(long long)timeInterval
{
    //为了让 format 显示一样的日期，所以要 加上 [NSTimeZone localTimeZone].secondsFromGMT
    return [self dateOnlyWithTimeInterval:timeInterval + [NSTimeZone localTimeZone].secondsFromGMT];
}

//反回只有日期，没有时间的 时间戳
+(NSTimeInterval)dateOnlyWithTimeInterval:(NSTimeInterval)timeInterval
{
    static double daySeconds = 24 * 60 * 60;
    //calculate integer type of days
    long allDays = floor(timeInterval / daySeconds);
    
    NSTimeInterval secs = allDays * daySeconds;
    
    return secs;
}

//获取年月日如:19871127.
-(NSString *)intDate
{
    NSString *string = [NSString stringWithFormat:@"%d%02d%02d",
                         (int)[self getYear], (int)[self getMonth], (int)[self getDay]];
    return string;
}

-(NSDate*)dateOnly
{
    NSTimeInterval interval = [self timeIntervalSince1970];
    NSTimeInterval secs = [[self class] dateOnlyWithTimeInterval:interval];
    return [NSDate dateWithTimeIntervalSince1970:secs];
}

//返回当前月一共有几周(可能为4,5,6)
-(int)getWeekNumOfMonth
{
    return [[self endOfMonth] getWeekOfYear] - [[self beginningOfMonth] getWeekOfYear] + 1;
}

//该日期是该年的第几周
-(int)getWeekOfYear
{
    int i;
    
    int year = (int)[self getYear];
    
    NSDate *date = [self endOfWeek];
    
    for (i = 1;[[date dateAfterDay:-7 * i] getYear] == year;i++) 
    {
    }
    return i;
}

//返回day天后的日期(若day为负数,则为|day|天前的日期)
- (NSDate *)dateAfterDay:(NSInteger)day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // Get the weekday component of the current date
    // NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    
    // to get the end of week for a particular date, add (7 - weekday) days
    [componentsToAdd setDay:day];
    NSDate *dateAfterDay = [calendar dateByAddingComponents:componentsToAdd
                                                     toDate:self
                                                    options:NSCalendarWrapComponents];
    
#if ! __has_feature(objc_arc)
    [componentsToAdd release];
#endif

    return dateAfterDay;
}

//计算两个日期之间的天数
-(NSInteger)daysFromDate:(NSDate*)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitDay
                                         fromDate:date toDate:self
                                          options:NSCalendarWrapComponents];
    return comp.day;
}

//month个月后的日期
-(NSDate *)dateafterMonth:(NSInteger)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    [componentsToAdd setMonth:month];
    
    NSDate *dateAfterMonth = [calendar dateByAddingComponents:componentsToAdd
                                                       toDate:self
                                                      options:NSCalendarWrapComponents];
#if ! __has_feature(objc_arc)
    [componentsToAdd release];
#endif
    
    return dateAfterMonth;
}

//获取日
-(int)getDay{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSDayCalendarUnit) fromDate:self];
    return (int)[dayComponents day];
}

//获取月
-(int)getMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSMonthCalendarUnit) fromDate:self];
    return (int)[dayComponents month];
}

//获取年
-(int)getYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dayComponents = [calendar components:(NSYearCalendarUnit) fromDate:self];
    return (int)[dayComponents year];
}

//获取小时
- (int)getHour{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSUInteger unitFlags =NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit;
    
    NSDateComponents *components = [calendar components:unitFlags fromDate:self];
    NSInteger hour = [components hour];
    return (int)hour;
}

//获取分钟
-(int)getMinute{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSUInteger unitFlags =NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit;
    
    NSDateComponents *components = [calendar components:unitFlags fromDate:self];
    
    NSInteger minute = [components minute];
    
    return (int)minute;
    
}

-(int)getHour:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSUInteger unitFlags =NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit;
    
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    
    NSInteger hour = [components hour];
    
    return (int)hour;
}

- (int)getMinute:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSUInteger unitFlags =NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSHourCalendarUnit |NSMinuteCalendarUnit;
    
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    
    NSInteger minute = [components minute];
    
    return (int)minute;
    
}

//在当前日期前几天
- (NSInteger)daysAgo {
    
    return [[NSDate date] daysFromDate:self];
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *components = [calendar components:(NSDayCalendarUnit) 
//                                               fromDate:self
//                                                 toDate:[NSDate date]
//                                                options:0];
//    
//    return [components day];
}

//午夜时间距今几天
- (NSInteger)daysAgoAgainstMidnight {
    
    // get a midnight version of ourself:
    NSDateFormatter *mdf = [[self class] dateFormatter];
    NSDate *midnight = [mdf dateFromString:[mdf stringFromDate:self]];

    return [midnight timeIntervalSinceNow] / (60*60*24) *-1;
}

-(NSString *)stringDaysAgo {
    
    return [self stringDaysAgoAgainstMidnight:YES];
}

-(NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag {
    
    NSUInteger daysAgo = (flag) ? [self daysAgoAgainstMidnight] : [self daysAgo];
    
    NSString *text = SStringEmpty;
    
    switch (daysAgo) {
            
        case 0:
            
            text = @"Today";
            
            break;
            
        case 1:
            
            text = @"Yesterday";
            
            break;
            
        default:
            
            text = [NSString stringWithFormat:@"%d days ago", (int)daysAgo];
            
    }
    
    return text;
    
}

//显示 中文 日期时间
-(NSString *)stringDaysCNWithTime:(BOOL)showTime Symbol:(BOOL)symbol  showMinute:(BOOL)showMinute
{
    NSString *sText = SStringEmpty;
    
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitMinute  //年、月、日、时、分、秒、周等等都可以
                                           fromDate:self
                                             toDate:[NSDate date]
                                            options:NSCalendarWrapComponents];
    NSInteger minutes = [comps minute];//时间差
    if (minutes < 1)
    {
        minutes = 1;
    }
        
    if (showMinute && minutes < 59)
    {
        showTime   = NO;
        sText = [NSString stringWithFormat:@"%d分钟前", (int)minutes];
    }
    else
    {
        NSInteger daysAgo = [self daysAgoAgainstMidnight];
        
        switch (daysAgo) {
                
            case 0:
            {
                showTime = true;  //今天 也必须显示 时间
            }
                break;
                
            case 1:
                sText = @"昨天";
                break;
            case 2:
                sText = @"前天";
                break;
            default:
            {
                NSDateFormatter *outputFormatter = [[self class] cnMonthDayFormatter];
                NSDate *date = [NSDate date];
                if ([date getYear] != [self getYear])  //如果不是当年,显示年份
                    outputFormatter = [[self class] cnYearMonthDayFormatter];
                sText = [outputFormatter stringFromDate:self];
            }
        }
        
    }
    
    
    if (showTime)
    {
        NSDateFormatter *outputFormatter = symbol ? [NSDate cnShortHourMinuteFormatter] :
        [NSDate cnLongHourMinuteFormatter];
        NSString *sTime = [outputFormatter stringFromDate:self];
        if (symbol)
        {
            int hour = [self getHour];
            NSString *sSymbol = SStringEmpty;
            if (hour < 6)
                sSymbol = @"凌晨";
            else
            if (hour < 12)
                sSymbol = @"上午";
            else
            if (hour < 18)
                sSymbol = @"下午";
            else
                sSymbol = @"晚上";
            if (hour > 12)
            {
                hour -= 12;
                //系统 如果设置为24小时制时, 小时无法转为12小时制
                int h = [[sTime substringWithRange:NSMakeRange(0, 2)] intValue];
                if (h != hour)
                {
                    NSMutableString *s = [NSMutableString stringWithFormat:@"%d", hour];
                    if (hour < 10)
                        [s insertString:@"0" atIndex:0];
                    [s appendString:[sTime substringWithRange:NSMakeRange(2, 3)]];
                    sTime = s;
                }
            }
            
            sTime = [NSString stringWithFormat:@"%@ %@", sSymbol, sTime];
        }
        if (sText.length > 0)
            sText = [sText stringByAppendingString:@" "];
        return [sText stringByAppendingString: sTime];
    }
    return sText;
}
//返回一周的第几天(周末为第一天)
- (int)weekDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *weekdayComponents = [calendar components:(NSWeekdayCalendarUnit) fromDate:self];
    
    return (int)[weekdayComponents weekday];
}

-(NSString*)weekDayStr
{
    return [[[self class] longWeekFormatter] stringFromDate:self];
}

//转为NSString类型的
+(NSDate*)dateFromString:(NSString *)string {
    
    return [NSDate dateFromString:string withFormat:SSQLDateTimeFormat];
}

+(NSDate*)dateFromString:(NSString *)string withFormat:(NSString *)format {
    
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:format];
    NSDate *date = [inputFormatter dateFromString:string];
#if ! __has_feature(objc_arc)
    [inputFormatter release];
#endif
    return date;
}

+(NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed {
    
    /* 
     
     * if the date is in today, display 12-hour time with meridian,
     
     * if it is within the last 7 days, display weekday name (Friday)
     
     * if within the calendar year, display as Jan 23
     
     * else display as Nov 11, 2008
     
     */
    

    NSDate *today = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit calcUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *offsetComponents = [calendar components:calcUnit
                                                     fromDate:today];
    
    NSDate *midnight = [calendar dateFromComponents:offsetComponents];
    NSDateFormatter *displayFormatter = [[NSDateFormatter alloc] init];
    NSString *displayString = SStringEmpty;
    
    // comparing against midnight
    if ([date compare:midnight] == NSOrderedDescending) {
        if (prefixed) {
            [displayFormatter setDateFormat:@"'at' h:mm a"]; // at 11:30 am
        } else {
            [displayFormatter setDateFormat:@"h:mm a"]; // 11:30 am
        }
    } else {
        // check if date is within last 7 days
        NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
        [componentsToSubtract setDay:-7];
        NSDate *lastweek = [calendar dateByAddingComponents:componentsToSubtract toDate:today
                                                    options:NSCalendarWrapComponents];
        
#if ! __has_feature(objc_arc)
        [componentsToSubtract release];
#endif
        if ([date compare:lastweek] == NSOrderedDescending) {
            [displayFormatter setDateFormat:@"EEEE"]; // Tuesday
        } else {
            // check if same calendar year
            NSInteger thisYear = [offsetComponents year];
            NSDateComponents *dateComponents = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay)
                                                           fromDate:date];
            
            NSInteger thatYear = [dateComponents year];
            if (thatYear >= thisYear) {
                [displayFormatter setDateFormat:@"MMM d"];
            } else {
                [displayFormatter setDateFormat:@"MMM d, yyyy"];
            }
            
        }
        
        if (prefixed) {
            NSString *dateFormat = [displayFormatter dateFormat];
            NSString *prefix = @"'on' ";
            [displayFormatter setDateFormat:[prefix stringByAppendingString:dateFormat]];   
        }
    }
    
    // use display formatter to return formatted date string
    displayString = [displayFormatter stringFromDate:date];
    
#if ! __has_feature(objc_arc)
    [displayFormatter release];
#endif

    return displayString;
}

+ (NSString *)stringForDisplayFromDate:(NSDate *)date {
    return [self stringForDisplayFromDate:date prefixed:NO];
}

- (NSString *)stringWithFormat:(NSString *)format {
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateFormat:format];
    NSString *timestamp_str = [outputFormatter stringFromDate:self];
    
#if ! __has_feature(objc_arc)
    [outputFormatter release];
#endif
    return timestamp_str;
}

-(NSString *)string{
    
    NSDateFormatter *outputFormatter = [NSDate dateTimeFormatter];

    return [outputFormatter stringFromDate:self];
}

-(NSString*)dateString
{
    return [[NSDate dateFormatter] stringFromDate:self];
}

-(NSString*)dateTimeString
{
    return [[NSDate dateTimeFormatter] stringFromDate:self];
}

-(NSString*)timeString
{
    return [[NSDate timeFormater] stringFromDate:self];
}

-(NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle {
    
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setDateStyle:dateStyle];
    [outputFormatter setTimeStyle:timeStyle];
    NSString *outputString = [outputFormatter stringFromDate:self];
#if ! __has_feature(objc_arc)
    [outputFormatter release];
#endif
    return outputString;
}

//返回周日的的开始时间
-(NSDate *)beginningOfWeek {
    // largely borrowed from "Date and Time Programming Guide for Cocoa"
    // we'll use the default calendar and hope for the best
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *beginningOfWeek = [NSDate date];
    BOOL ok = [calendar rangeOfUnit:NSWeekCalendarUnit startDate:&beginningOfWeek
                           interval:NULL forDate:self];
    if (ok) {
        return beginningOfWeek;
    }
    // couldn't calc via range, so try to grab Sunday, assuming gregorian style
    // Get the weekday component of the current date
    
    NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
    /*
     Create a date components to represent the number of days to subtract from the current date.
     The weekday value for Sunday in the Gregorian calendar is 1, so subtract 1 from the number of days to subtract from the date in question.  (If today's Sunday, subtract 0 days.)
     */
    
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay: 0 - ([weekdayComponents weekday] - 1)];
    
    beginningOfWeek = nil;
    beginningOfWeek = [calendar dateByAddingComponents:componentsToSubtract toDate:self options:0];
    
#if ! __has_feature(objc_arc)
    [componentsToSubtract release];
#endif
    
    //normalize to midnight, extract the year, month, and day components and create a new date from those components.
    NSCalendarUnit calcUnit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *components = [calendar components:calcUnit
                                               fromDate:beginningOfWeek];
    
    return [calendar dateFromComponents:components];
}

//返回当前天的年月日
-(NSDate *)beginningOfDay {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // Get the weekday component of the current date
    NSDateComponents *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay
                                               fromDate:self];
    return [calendar dateFromComponents:components];
}

//返回该月的第一天
-(NSDate *)beginningOfMonth
{
    return [self dateAfterDay:-(int)[self getDay] + 1];
}

//该月的最后一天
-(NSDate *)endOfMonth
{
    return [[[self beginningOfMonth] dateafterMonth:1] dateAfterDay:-1];
}

//返回当前周的周末
-(NSDate *)endOfWeek {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // Get the weekday component of the current date
    NSDateComponents *weekdayComponents = [calendar components:NSWeekdayCalendarUnit fromDate:self];
    NSDateComponents *componentsToAdd = [[NSDateComponents alloc] init];
    // to get the end of week for a particular date, add (7 - weekday) days
    [componentsToAdd setDay:(7 - [weekdayComponents weekday])];
    NSDate *endOfWeek = [calendar dateByAddingComponents:componentsToAdd
                                                  toDate:self
                                                 options:NSCalendarWrapComponents];
    
#if ! __has_feature(objc_arc)
    [componentsToAdd release];
#endif
    return endOfWeek;
}


@end
