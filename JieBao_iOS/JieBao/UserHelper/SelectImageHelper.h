//
//  SelectImageHelper.h
//  JieBao
//
//  Created by yangzhenmin on 2018/4/27.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceModel.h"

@interface SelectImageHelper : NSObject

+ (UIImage *)selectImageWithTpye:(DeviceTpye)type;

+ (UIImage *)selectGroupImageWithTpye:(NSString *)type;

+ (UIImage *)selectGroupSelectedImageWithTpye:(NSString *)type;

/**
 *  设置设备关闭状态
 *
 */
+ (UIImage *)selectDeviceImageWithTpye:(NSString *)type;

/**
 * 设置设备开启状态
 *
 */
+ (UIImage *)selectDeviceSelectedImageWithTpye:(NSString *)type;

/**
 * 设置设备未连接状态
 *
 */
+ (UIImage *)selectDeviceNoConnectedWithTpye:(NSString *)type;

@end
