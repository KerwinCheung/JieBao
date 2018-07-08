//
//  CustomDevice.h
//  JieBao
//
//  Created by yangzhenmin on 2018/6/4.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomDevice : NSObject

/**
string    该分组下的设备ID
 */
@property (nonatomic, copy) NSString *did;
/**
 string    设备类型：普通设备：noramal；中控设备：center_control；中控子设备：sub_dev
 */
@property (nonatomic, copy) NSString *type;
/**
string    产品名称，单PK的分组才会有值
 */
@property (nonatomic, copy) NSString *verbose_name;
/**
string    设备别名
 */
@property (nonatomic, copy) NSString *dev_alias;

/**
 string    产品 product_key，单PK的分组才会有值
 */
@property (nonatomic, copy) NSString *product_key;

@property (nonatomic, copy) NSString *product_name;

@property (nonatomic, copy) NSString *remark;

@end
