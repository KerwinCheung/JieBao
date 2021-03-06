//
//  SDKHelper.h
//  JieBao
//
//  Created by yangzhenmin on 2018/4/25.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SDKHELPER [SDKHelper shareInstance]
@class CustomDeviceGroup;
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

@property (nonatomic, copy) GetShareListCallBackBlock getShareListCallBackBlock;

/**设备状态字典    key 为设备did value 为数据点模型*/
@property (nonatomic, strong) NSMutableDictionary *statusDic;

/**当前账号绑定的设备数组 GizWifiDevice对象*/
@property (nonatomic, strong) NSMutableArray *deviceArray;

/**当前账号绑定的分组数组 CustomeGroup对象*/
@property (nonatomic, strong) NSMutableArray *groupsArray;


+ (instancetype)shareInstance;

/**
 * 校验该设备是否已经加入进了分组中
 * @param dev GizWifiDevice对象
 * @return bool值
 */
-(BOOL)isExistingGroupWith:(GizWifiDevice *)dev;

/**
 * 将分组从本地移除
 * @param group 要移除的分组对象
 */
-(void)removeGourpFromLocalWith:(CustomDeviceGroup *)group;

/**
 * 添加分组对象到本地
 * @param group 要添加的分组对象
 */
-(void)addGroupToLocalWith:(CustomDeviceGroup *)group;
@end
