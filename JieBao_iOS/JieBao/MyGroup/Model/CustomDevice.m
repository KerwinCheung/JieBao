//
//  CustomDevice.m
//  JieBao
//
//  Created by yangzhenmin on 2018/6/4.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "CustomDevice.h"

@implementation CustomDevice

-(instancetype)initWithGizwifDev:(GizWifiDevice *)dev{
    if (self = [super init]) {
        self.did= dev.did;
        self.product_key = dev.productKey;
        self.product_name = dev.productName;
        self.dev_alias = dev.alias;
        self.remark = dev.remark;
    }
    return self;
}

@end
