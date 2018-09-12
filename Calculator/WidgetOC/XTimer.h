//
//  XTimer.h
//  zyt-ios
//
//  Created by xinyu_mac on 16/9/8.
//  Copyright © 2016年 tcxy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XTimer : NSObject

/**计时器的block方法*/
@property (nonatomic, copy) void (^timerBlock)(void);

/**开始计时器*/
- (void)startTimer:(NSTimeInterval)timeInterval;

/**结束计时器*/
- (void)endTimer;

/**获取当前时间*/
+ (NSString *)getNowTime;

/**比较当前时间*/
+ (BOOL)compareNowTime:(NSString *) time;

/**时间戳转时间*/
+ (NSString *)timeFromTimestamp:(NSTimeInterval) timestamp withDateFormat:(NSString *) dateFormat;

/**时间转时间戳*/
+ (NSTimeInterval)timestampFromTime:(NSString *) time;

/**时间差*/
+ (NSString *)timeDifFromBeginTime:(NSString *) beginTime withEndTime:(NSString *) endTime;
+ (NSTimeInterval)timestampDifFromBeginTime:(NSString *) beginTime withEndTime:(NSString *) endTime;

/**NSDate与NSString转换*/
+ (NSDate *)dateFromString:(NSString *)dateString;
+ (NSString *)stringFromDate:(NSDate *)date;

@end
