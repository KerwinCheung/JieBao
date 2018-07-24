//
//  SDKHelper.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/25.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "SDKHelper.h"
#import "LightsDataPointModel.h"
static SDKHelper *helper = nil;

@interface SDKHelper()

@end

@implementation SDKHelper

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[super allocWithZone:NULL] init];
        helper.statusDic = [NSMutableDictionary dictionary];
        helper.deviceArray = [NSMutableArray array];
    });
    return helper;
}

- (void)wifiSDK:(GizWifiSDK *)wifiSDK didNotifyEvent:(GizEventType)eventType eventSource:(id)eventSource eventID:(GizWifiErrorCode)eventID eventMessage: (NSString *)eventMessage {
    if(eventType == GizEventSDK) {
        // SDK发生异常的通知
        LHLog(@"SDK event happened: [%@] = %@", @(eventID), eventMessage);
    } else if(eventType == GizEventDevice) {
        // 设备连接断开时可能产生的通知
        GizWifiDevice* mDevice = (GizWifiDevice*)eventSource;
        LHLog(@"device mac %@ disconnect caused by %@", mDevice.macAddress, eventMessage);
    } else if(eventType == GizEventM2MService) {
        // M2M服务返回的异常通知
        LHLog(@"M2M domain %@ exception happened: [%@] = %@", (NSString*)eventSource, @(eventID), eventMessage);
    } else if(eventType == GizEventToken) {
        // token失效通知
        LHLog(@"token %@ expired: %@", (NSString*)eventSource, eventMessage);
    }
}

- (void)wifiSDK:(GizWifiSDK *)wifiSDK didRegisterUser:(NSError *)result uid:(NSString *)uid token:(NSString *)token
{
    if(result.code == GIZ_SDK_SUCCESS) {
        // 注册成功
        if (self.registerBlock) {
            self.registerBlock(YES);
        }
    }else if (result.code ==  GIZ_OPENAPI_CODE_INVALID)
    {
        [HudHelper showErrorWithStatus:@"验证码错误"];
    }
    else
    {
        if (self.registerBlock) {
            self.registerBlock(NO);
        }
    }
}


- (void)wifiSDK:(GizWifiSDK *)wifiSDK didUserLogin:(NSError *)result uid:(NSString *)uid token:(NSString *)token {
    if(result.code == GIZ_SDK_SUCCESS) {
        UserModel *model = [UserHelper getCurrentUser];
        model.uid = uid;
        model.token = token;
        [UserHelper setCurrentUser:model];
        [[NSNotificationCenter defaultCenter] postNotificationName:kUserLoginKey object:nil];
        // 登录成功
        if (self.loginBlock) {
            self.loginBlock(YES);
        }
    }else if (result.code ==  GIZ_OPENAPI_PHONE_UNAVALIABLE)
    {
       [HudHelper showErrorWithStatus:@"输入正确手机号"];
    }else if (result.code ==  GIZ_OPENAPI_USERNAME_PASSWORD_ERROR)
    {
        [HudHelper showErrorWithStatus:@"密码错误"];
    }else if (result.code ==  GIZ_OPENAPI_CODE_INVALID)
    {
        [HudHelper showErrorWithStatus:@"验证码错误"];
    }else if (result.code == GIZ_OPENAPI_USER_NOT_EXIST)
    {
        [HudHelper showErrorWithStatus:@"手机号未注册"];
    }
    else
    {
        if (self.loginBlock) {
            self.loginBlock(NO);
        }
    }
}

- (void)wifiSDK:(GizWifiSDK *)wifiSDK didChangeUserPassword:(NSError *)result {
    if(result.code == GIZ_SDK_SUCCESS) {
        // 修改成功
        if (self.resetPswBlock) {
            self.resetPswBlock(YES);
        }
        [HudHelper showStatus:@"重置成功"];
    }else if (result.code ==  GIZ_OPENAPI_CODE_INVALID)
    {
        [HudHelper showStatus:@"验证码错误"];
    }else if (result.code ==  GIZ_OPENAPI_PHONE_UNAVALIABLE)
    {
        [HudHelper showStatus:@"输入正确手机号"];
    }else if (result.code == GIZ_OPENAPI_USER_NOT_EXIST)
    {
        [HudHelper showStatus:@"手机号未注册"];
    }
    else
    {
        if (self.resetPswBlock) {
            self.resetPswBlock(NO);
        }
    }
}


- (void)wifiSDK:(GizWifiSDK *)wifiSDK didSetDeviceOnboarding:(NSError *)result mac:(NSString *)mac did:(NSString *)did productKey:(NSString *)productKey {
    if(result.code == GIZ_SDK_SUCCESS) {
        // 配置成功
        if (self.onboardingCallBackBlock) {
            self.onboardingCallBackBlock(YES);
        }
    }else
    {
        if (self.onboardingCallBackBlock) {
            self.onboardingCallBackBlock(NO);
        }
    }
}

- (void)wifiSDK:(GizWifiSDK *)wifiSDK didBindDevice:(NSError *)result did:(NSString *)did {
    if(result.code == GIZ_SDK_SUCCESS) {
        // 绑定成功
        if (self.bindDeviceBlock) {
            self.bindDeviceBlock(YES);
        }
    } else {
        // 绑定失败
        if (self.bindDeviceBlock) {
            self.bindDeviceBlock(NO);
        }
    }
}

- (void)wifiSDK:(GizWifiSDK *)wifiSDK didUnbindDevice:(NSError *)result did:(NSString *)did
{
     if(result.code == GIZ_SDK_SUCCESS) {
         if (self.unBindDeviceBlock) {
             self.unBindDeviceBlock(YES,0);
         }
     }else
     {
         if (self.unBindDeviceBlock) {
             self.unBindDeviceBlock(NO,result.code);
         }
     }
}

- (void)wifiSDK:(GizWifiSDK *)wifiSDK didDiscovered:(NSError * _Nonnull)result deviceList:(NSArray<GizWifiDevice *> * _Nullable)deviceList{
    // 提示错误原因
    if(result.code != GIZ_SDK_SUCCESS) {
        LHLog(@"result: %@", result.localizedDescription);
    }
    // 显示变化后的设备列表
    LHLog(@"discovered deviceList: %@", deviceList);
    if (self.discoverDeviceBlock) {
        self.discoverDeviceBlock(deviceList);
    }
}

- (void)didSharingDevice:(NSError *)result deviceID:(NSString *)deviceID sharingID:(NSInteger)sharingID QRCodeImage:(UIImage *)QRCodeImage
{
    if(result.code == GIZ_SDK_SUCCESS) {
        if (self.shareCallBackBlock) {
            self.shareCallBackBlock(YES);
        }
    }else{
        [HudHelper showErrorWithStatus:[NSString stringWithFormat:@"分享失败%ld",result.code]];
        if (self.shareCallBackBlock) {
            self.shareCallBackBlock(NO);
        }
    }
}

- (void)didUpdateSchedulers:(GizWifiDevice*)schedulerOwner result:(NSError*)result schedulerList:(NSArray*)schedulerList {
    if(result.code == GIZ_SDK_SUCCESS) {
        // 定时任务创建成功
        if (self.scheduleCallBackBlock) {
            self.scheduleCallBackBlock(schedulerList);
        }
    } else {
        // 创建失败
        if (self.scheduleCallBackBlock) {
            self.scheduleCallBackBlock(nil);
        }
    }
}






@end
