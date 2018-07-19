//
//  UntilHelper.h
//  JieBao
//
//  Created by yangzhenmin on 2018/5/1.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ErrorModel.h"
@class DeviceSchedulerTask;
@interface UtilHelper : NSObject

+ (id)fetchSSIDInfo;

+ (NSString *)getSSID;

+ (NSString *)md5:(NSString *)str;

+ (NSMutableArray<ErrorModel *> *)getErrorLists;

+ (void)setErrorList:(ErrorModel *)error;

+ (void)setWifiLocalize:(NSMutableDictionary *)wifi;

+ (NSMutableDictionary *)getWifi;

+ (BOOL) isValidateMobile:(NSString *)mobile;

/**
 * 检查此彩灯定时任务组是否执行
 */
+(BOOL)checkTaskIsEnabledWithTask:(DeviceSchedulerTask *)task;

/**
 * 获取当前时间的时间戳
 */
+(NSString *)getTimeStampStr;

/**
 * 将当前时间转化为字符串，格式为：yyyy-MM-dd
 */
+ (NSString *)stringFromDate:(NSDate *)date;

/**
 * 将格式为 yyyy-MM-dd HH:mm 格式的字符串转换位NSDate
 */
+ (NSDate *)dateFromString:(NSString *)string;

@end
