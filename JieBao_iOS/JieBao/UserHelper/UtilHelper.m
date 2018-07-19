//
//  UntilHelper.m
//  JieBao
//
//  Created by yangzhenmin on 2018/5/1.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "UtilHelper.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "CommonCrypto/CommonDigest.h"
#import "DeviceSchedulerTask.h"
@implementation UtilHelper

//NSDate转NSString
+ (NSString *)stringFromDate:(NSDate *)date
{
    //获取系统当前时间
    NSDate *currentDate = [NSDate date];
    //用于格式化NSDate对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd "];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:currentDate];
    //输出currentDateString
    NSLog(@"%@",currentDateString);
    return currentDateString;
}

//NSString转NSDate
+ (NSDate *)dateFromString:(NSString *)string
{
    //需要转换的字符串
    NSString *dateString = string;
    //设置转换格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    //NSString转NSDate
    NSDate *date=[formatter dateFromString:dateString];
    return date;
}

+(NSString *)getTimeStampStr{
    //获取当前的时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%ld", (long)a];
    return timeString;
}
+(BOOL)checkTaskIsEnabledWithTask:(DeviceSchedulerTask *)task{
    //检验此定时任务是否执行中，当有一半的定时器为执行时就默认此定时组是执行中
    BOOL isEnable = NO;
    if (task.sches.count == 0) {
        return isEnable;
    }
    NSInteger mark = 0;
    for (DeviceCommonSchulder *timer in task.sches) {
        if (timer.enabled) {
            mark++;
        }
    }
    if (mark >= (task.sches.count/2)) {
        isEnable = YES;
    }
    
    return isEnable;
}

+ (id)fetchSSIDInfo {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        if (info && [info count]) { break; }
    }
    return info;
}

+ (NSString *)getSSID
{
    return [[self fetchSSIDInfo] objectForKey:@"SSID"];
}

+ (NSString *)md5:(NSString *)str
{
    NSInteger timestap = [NSDate date].timeIntervalSince1970;
    NSString *tempStr = [NSString stringWithFormat:@"%@%ld",str,timestap];
    const char *cStr = [tempStr UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

+ (NSMutableArray<ErrorModel *> *)getErrorLists
{
    return ((NSDictionary *)UserDefaultObject(kErrorListsKey))[[UserHelper getCurrentUser].userName];
}

+ (void)setErrorList:(ErrorModel *)error
{
    NSMutableArray *arr = [self getErrorLists];
    if (!arr) {
        arr = [NSMutableArray array];
    }
    [arr addObject:error];
    NSDictionary *dic = @{[UserHelper getCurrentUser].userName:arr};
    SetUserDefaultObject(kErrorListsKey, dic);
}

+ (void)setWifiLocalize:(NSMutableDictionary *)wifi
{
    NSMutableDictionary *dic = [self getWifi];
    if (!dic) {
        dic = [NSMutableDictionary dictionary];
    }
#warning 有时会崩溃所以屏蔽掉，貌似是存wifi密码
//    [dic setObject:wifi[kUserWIFINameKey] forKey:wifi[kUserWIFIPSWKey]];
//    SetUserDefaultObject(kUserWIFIKey, dic);
}

+ (NSMutableDictionary *)getWifi
{
    return (NSMutableDictionary *)UserDefaultObject(kUserWIFIKey);
}

+ (BOOL) isValidateMobile:(NSString *)mobile
{
    /*
     //手机号以13， 15，18开头，八个 \\d 数字字符
     NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\\\D])|(18[0,0-9]))\\\\d{8}$";
     NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
     return [phoneTest evaluateWithObject:mobile];
     */
    
    NSPredicate* phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"1[34578]([0-9]){9}"];
    return [phoneTest evaluateWithObject:mobile];
}

@end
