//
//  AddDeviceViewController.h
//  JieBao
//
//  Created by yangzhenmin on 2018/4/14.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "BaseViewController.h"
#import "CustomDeviceGroup.h"

@interface AddDeviceViewController : BaseViewController

@property (nonatomic, strong) CustomDeviceGroup *group;

@property (nonatomic, copy) VCCallBackBlock callback;

@end
