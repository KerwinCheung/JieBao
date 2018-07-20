//
//  BlockDefine.h
//  JieBao
//
//  Created by yangzhenmin on 2018/4/16.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#ifndef BlockDefine_h
#define BlockDefine_h

typedef void(^ActionBlock)(UIButton *btn);

typedef void(^RegisterCallBackBlock)(BOOL success);

typedef void(^LoginCallBackBlock)(BOOL success);

typedef void(^ResetPswCallBackBlock)(BOOL success);

typedef void(^DeviceOnboardingCallBackBlock)(BOOL success);

typedef void(^BindDeviceCallBackBlock)(BOOL success);

typedef void(^UnBindDeviceCallBackBlock)(BOOL success,NSInteger errcode);

typedef void(^DiscoverDeviceCallBackBlock)(NSArray * devs);

typedef void(^ShareCallBackBlock)(BOOL success);

typedef void(^ScheduleCallBackBlock)(NSArray *list);

typedef void (^VCCallBackBlock)(id obj);
#endif /* BlockDefine_h */
