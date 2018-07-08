//
//  TimingSettingViewController.h
//  JieBao
//
//  Created by yangzhenmin on 2018/5/9.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "BaseViewController.h"
#import "DeviceSchedulerTask.h"
#import "CustomDeviceGroup.h"

@interface TimingSettingViewController : BaseViewController

@property (nonatomic, strong) GizWifiDevice *dev;

@property (nonatomic, strong) CustomDeviceGroup *group;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, strong) DeviceSchedulerTask *schTask;

@property (nonatomic, strong) NSMutableArray<NSString *> *nameSoure;

@end
