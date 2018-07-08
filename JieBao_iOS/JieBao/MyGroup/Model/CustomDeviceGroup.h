//
//  CustomDeviceGroup.h
//  JieBao
//
//  Created by yangzhenmin on 2018/6/4.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomDevice.h"

@interface CustomDeviceGroup : NSObject

/**
 string    设备分组创建时间（UTC 时间）
 */
@property (nonatomic, copy) NSString *created_at;

/**
     string    设备分组更新时间（UTC 时间）
 */
@property (nonatomic, copy) NSString *updated_at;

/**
     string    产品 product_key，单PK的分组才会有值
 */
@property (nonatomic, copy) NSString *product_key;

/**
     string    设备分组名称
 */
@property (nonatomic, copy) NSString *group_name;

/**
     string    产品名称，单PK的分组才会有值
 */
@property (nonatomic, copy) NSString *verbose_name;

/**
     string    设备分组 id
 */
@property (nonatomic, copy) NSString *gid;

/**
 分组的设备
 */
@property (nonatomic, strong) NSArray<CustomDevice *> *devs;

@end
