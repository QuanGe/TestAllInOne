//
//  NSDate+Common.m
//  QGOCCategory
//
//  Created by 张如泉 on 15/10/5.
//  Copyright © 2015年 QuanGe. All rights reserved.
//

#import "NSDate+Common.h"

@implementation NSDate (Common)

/**
 *  将字符串转化为日期。yyyy/MM/dd HH:mm:ss
 *  @param  string:给定的字符串日期。
 *  return  返回转化后的日期。
 */
+ (NSDate *)qgocc_dateFromString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    
    [[NSUserDefaults standardUserDefaults] setObject:destDate forKey:@"now"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSDate *now = [[NSUserDefaults standardUserDefaults] valueForKey:@"now"];
    return now;
    
}

/**
 *  将日期转化为简短的日期格式字符串
 *
 *  return  日期的简短字符串。
 */
- (NSString *)qgocc_timestampForDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDoesRelativeDateFormatting:YES];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    return [dateFormatter stringFromDate:self];
}

/**
 *  将日期转化为字符串。
 *  @param  format:转化格式，形如@"yyyy年MM月dd日hh时mm分ss秒"。
 *  return  返回转化后的字符串。
 */
- (NSString *)qgocc_convertDateToStringWithFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSString *dateStr = [dateFormatter stringFromDate:self];
    return dateStr;
}

/**
 *  将字符串转化为日期。
 *  @param  string:给定的字符串日期。
 *  @param  format:转化格式，形如@"yyyy年MM月dd日hh时mm分ss秒"。日期格式要和string格式一致，否则会为空。
 *  return  返回转化后的日期。
 */
- (NSDate *)qgocc_convertStringToDate:(NSString *)string format:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:format];
    NSDate *date = [dateFormatter dateFromString:string];
    return date;
}
@end
