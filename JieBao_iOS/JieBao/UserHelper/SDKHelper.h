//
//  SDKHelper.h
//  JieBao
//
//  Created by yangzhenmin on 2018/4/25.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SDKHELPER [SDKHelper shareInstance]

@interface SDKHelper : NSObject<GizWifiSDKDelegate,GizDeviceGroupCenterDelegate,GizDeviceSharingDelegate,GizDeviceSchedulerCenterDelegate>

@property (nonatomic, copy) RegisterCallBackBlock registerBlock;

@property (nonatomic, copy) LoginCallBackBlock loginBlock;

@property (nonatomic, copy) ResetPswCallBackBlock resetPswBlock;

@property (nonatomic, copy) DeviceOnboardingCallBackBlock onboardingCallBackBlock;

@property (nonatomic, copy) BindDeviceCallBackBlock bindDeviceBlock;

@property (nonatomic, copy) UnBindDeviceCallBackBlock unBindDeviceBlock;

@property (nonatomic, copy) DiscoverDeviceCallBackBlock discoverDeviceBlock;

@property (nonatomic, copy) ShareCallBackBlock shareCallBackBlock;

@property (nonatomic, copy) ScheduleCallBackBlock scheduleCallBackBlock;

/**设备状态字典    key 为设备did value 为数据点模型*/
@property (nonatomic, strong) NSMutableDictionary *statusDic;

/**当前账号绑定的设备数组 GizWifiDevice对象*/
@property (nonatomic, strong) NSMutableArray *deviceArray;


+ (instancetype)shareInstance;

@end
