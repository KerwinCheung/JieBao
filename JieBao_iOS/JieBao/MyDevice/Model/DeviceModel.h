//
//  DeviceModel.h
//  JieBao
//
//  Created by yangzhenmin on 2018/4/26.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "BaseModel.h"

typedef NS_ENUM(NSInteger,DeviceTpye)
{
    DeviceTpyeNone = 0,
    DeviceTpyeZaoLangBeng,
    DeviceTpyeShuiBeng,
    DeviceTpyeCaiDeng,
    DeviceTpyeKaiGuan,
    DeviceTpyeDianDiBeng,
    DeviceTpyeAdd
};

@interface DeviceModel : BaseModel<NSCoding>

@property (nonatomic, copy) NSString *deviceName;

@property (nonatomic, assign) DeviceTpye type;

@property (nonatomic, assign) BOOL selected;

@end
