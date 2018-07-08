//
//  SDKHelper.h
//  JieBao
//
//  Created by yangzhenmin on 2018/4/25.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <Foundation/Foundation.h>

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

+ (instancetype)shareInstance;

@end
