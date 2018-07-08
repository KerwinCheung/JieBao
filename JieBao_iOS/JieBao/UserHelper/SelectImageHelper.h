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

+ (UIImage *)selectDeviceImageWithTpye:(NSString *)type;

+ (UIImage *)selectDeviceSelectedImageWithTpye:(NSString *)type;

@end
