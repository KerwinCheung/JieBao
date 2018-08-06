//
//  LWHttpRequest.h
//  Zhenglisn2
//
//  Created by bagtree on 16/12/26.
//  Copyright © 2016年 wen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomDeviceGroup.h"
#import "CustomDevice.h"
#import "DeviceSchedulerTask.h"
#import "DeviceCommonSchulder.h"
typedef void (^requestBlock) (id result, NSError *err);

@interface LWHttpRequest : NSObject

/**
 * 获取分组列表
 * block 中返回（包含group对象的分组数组，错误error）
 */
+(void)getGroupListDidLoadData:(requestBlock)block;

/**
 * 获取分组详情
 * block 中返回（分组group 对象，错误error）
 */
+(void)getGroupDetailsWithGroup:(CustomDeviceGroup *)group
                    didLoadData:(requestBlock)block;

/**
 * 获取设备云端定时任务列表
 * @param did 设备id
 * block 中返回（包含DeviceCommonSchulder 对象的数组，错误error）
 */
+(void)getTimerListWithDid:(NSString *)did
                didLoadData:(requestBlock)block;
/**
 * 关闭定时器
 * @param   schulder DeviceCommonSchulder对象，通用定时任务对象
 * block 中返回(结果字典，错误error)
 */
+(void)closeTimerWithSchulder:(DeviceCommonSchulder *)schulder
                  didLoadData:(requestBlock)block;
@end
