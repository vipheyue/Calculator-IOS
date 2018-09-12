//
//  XTimer.m
//  zyt-ios
//
//  Created by xinyu_mac on 16/9/8.
//  Copyright © 2016年 tcxy. All rights reserved.
//

#import "XTimer.h"

@interface XTimer()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation XTimer

#pragma mark - 计时器相关
- (void)timerRepeats
{
    if (self.timerBlock) {
        self.timerBlock();
    }
}

- (void)startTimer:(NSTimeInterval)timeInterval
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(timerRepeats) userInfo:nil repeats:YES] ;
    _timer.fireDate = [NSDate distantPast];
}

- (void)endTimer
{
    _timer.fireDate = [NSDate distantFuture];
}

- (void)dealloc
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

#pragma mark - 获取当前时间
+ (NSString *)getNowTime
{
    NSDate *senddate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *locationString = [dateformatter stringFromDate:senddate];
    return locationString;
}

#pragma mark - 比较当前时间
+ (BOOL)compareNowTime:(NSString *) time
{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *thyDate = [dateformatter dateFromString:time];
//    NSLog(@"nowDate == %@, thyDate == %@", nowDate, thyDate);
    if ([nowDate compare:thyDate] == NSOrderedAscending) {
        return YES;
    }
    else {
        return NO;
    }
}

#pragma mark - 时间戳转时间
+ (NSString *)timeFromTimestamp:(NSTimeInterval) timestamp withDateFormat:(NSString *) dateFormat
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    if (dateFormat.length) {
        [formatter setDateFormat:dateFormat];
    }
    else {
        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    }
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
//    NSLog(@"confromTimespStr =  %@",confromTimespStr);
    return confromTimespStr;
}

#pragma mark - 时间转时间戳
+ (NSTimeInterval)timestampFromTime:(NSString *) time
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    NSDate *date = [formatter dateFromString:time];
    NSTimeInterval timeInterval = (NSTimeInterval)[date timeIntervalSince1970];
    return timeInterval;
}

#pragma mark - 时间差
+ (NSString *)timeDifFromBeginTime:(NSString *) beginTime withEndTime:(NSString *) endTime
{
    NSTimeInterval timeInterval = [self timestampFromTime:endTime] - [self timestampFromTime:beginTime];
    return [self timeFromTimestamp:timeInterval withDateFormat:@"mm:ss"];
}

+ (NSTimeInterval)timestampDifFromBeginTime:(NSString *) beginTime withEndTime:(NSString *) endTime
{
    return [self timestampFromTime:endTime] - [self timestampFromTime:beginTime];
}

#pragma mark - NSDate与NSString转换
+ (NSDate *)dateFromString:(NSString *)dateString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"YYYY-MM-dd HH:mm:ss"];
    NSDate *destDate= [dateFormatter dateFromString:dateString];
    return destDate;
}

+ (NSString *)stringFromDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //zzz表示时区，zzz可以删除，这样返回的日期字符将不包含时区信息。
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

@end
