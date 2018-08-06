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
@end
