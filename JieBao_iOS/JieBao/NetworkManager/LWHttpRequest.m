//
//  LWHttpRequest.m
//  Zhenglisn2
//
//  Created by bagtree on 16/12/26.
//  Copyright © 2016年 wen. All rights reserved.
//

#import "LWHttpRequest.h"
@implementation LWHttpRequest



#pragma mark - 获取分组列表
+(void)getGroupListDidLoadData:(requestBlock)block{
    NSString *path = @"https://api.gizwits.com/app/group";
    NSString *method = @"GET";
    [NetworkHelper sendRequest:nil Method:method Path:path callback:^(NSData *data, NSError *error) {
        if (!data || error) {
            block(nil,error);
            return;
        }
        NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (!jsonObject || ![jsonObject isKindOfClass:[NSArray class]]) {
            block(nil,error);
            return;
        }
        
        NSMutableArray *groupArray = [NSMutableArray array];
        for (NSDictionary *dic in jsonObject) {
            CustomDeviceGroup *group = [CustomDeviceGroup yy_modelWithJSON:dic];
            [groupArray addObject:group];
        }
        block(groupArray,nil);
        
    }];
}

#pragma mark - 获取分组详情
+(void)getGroupDetailsWithGroup:(CustomDeviceGroup *)group
                        didLoadData:(requestBlock)block{
    
    NSString *path = [NSString stringWithFormat:@"https://api.gizwits.com/app/group/%@/devices",group.gid];
    NSString *method = @"GET";
    [NetworkHelper sendRequest:nil Method:method Path:path callback:^(NSData *data, NSError *error) {
        if (!data || error) {
            block(nil,error);
            return;
        }
        NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSMutableArray *deviceArr = [NSMutableArray array];
        for (NSDictionary *dic in jsonObject) {
            CustomDevice *dev = [CustomDevice yy_modelWithJSON:dic];
            [deviceArr addObject:dev];
        }
        group.devs = deviceArr;
        block(group,nil);
    }];
}

#pragma mark - 获取设备远端定时任务列表
+(void)getTimerListWithDid:(NSString *)did
               didLoadData:(requestBlock)block{
    [NetworkHelper sendRequest:nil Method:@"GET" Path:[NSString stringWithFormat:@"https://api.gizwits.com/app/common_scheduler?%@&limit=200",did] callback:^(NSData *data, NSError *error) {
        if (!data || error) {
            block(nil,error);
            return ;
        }
        NSArray *list =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if ([list isKindOfClass:[NSMutableDictionary class]]) {
            NSDictionary *listDic = (NSDictionary *)list;
            if ([listDic.allKeys containsObject:@"error_code"]) {
                //有错误
                block(nil,nil);
                return;
            }
        }
        
        NSMutableArray *timerListArray = [NSMutableArray array];
        for (int i = 0; i< list.count; i++) {
            DeviceCommonSchulder *sch = [DeviceCommonSchulder yy_modelWithJSON:list[i]];
            [timerListArray addObject:sch];
        }
        block(timerListArray,nil);
    }];
}

#pragma mark - 关闭定时器
+(void)closeTimerWithSchulder:(DeviceCommonSchulder *)schulder
                didLoadData:(requestBlock)block{
    
    NSMutableDictionary *body = [NSMutableDictionary
                                 dictionaryWithDictionary:@{@"attrs":@{@"color_white":[schulder.attrs objectForKey:@"color_white"],
                                                                       @"color_blue1":[schulder.attrs objectForKey:@"color_blue1"],
                                                                       @"color_blue2":[schulder.attrs objectForKey:@"color_blue2"],
                                                                       @"color_green":[schulder.attrs objectForKey:@"color_green"],
                                                                       @"color_red":[schulder.attrs objectForKey:@"color_red"],
                                                                       @"volor_violet":[schulder.attrs objectForKey:@"volor_violet"],
                                                                       @"Timer" :[schulder.attrs objectForKey:@"Timer"]
                                                                       },
                                                            @"time":schulder.time,
                                                            @"repeat":@"mon,tue,wed,thu,fri,sat,sun",
                                                            @"enabled":@(0),
            @"remark":schulder.remark}];
    
        [body setObject:schulder.sid forKey:@"did"];

    
        [NetworkHelper sendRequest:body Method:@"PUT" Path:[NSString stringWithFormat:@"https://api.gizwits.com/app/common_scheduler/%@",schulder.sid] callback:^(NSData *data, NSError *error) {
            
            
            
            if (!data || error) {
                block(nil,error);
                return ;
            }
            NSDictionary *tempDic;
            if (data != nil) {
                tempDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",tempDic);
            }
            block(tempDic,error);
        }];
}



#pragma mark - method
+(NSString *)getSignOriginStrWithDic:(NSDictionary *)dic{

    NSArray *keys = [dic allKeys];
    NSArray *sortedArray = [keys sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 compare:obj2 options:NSNumericSearch];
    }];
    
    NSMutableString *contentString = [NSMutableString string];
    for (NSInteger i = 0;i<sortedArray.count;i++) {
        NSString * keyStr = [sortedArray objectAtIndex:i];
        if (i == sortedArray.count - 1) {
            [contentString appendFormat:@"%@%@",keyStr,[dic valueForKey:keyStr]];

        }else{
            [contentString appendFormat:@"%@%@",keyStr,[dic valueForKey:keyStr]];

        }
    }
    return contentString;
}

+(NSString *)getTimeStampStr{
    //获取当前的时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    NSString *timeString = [NSString stringWithFormat:@"%ld", (long)a];
    return timeString;
}

@end

