//
//  WeiShiSetStopViewController.h
//  JieBao
//
//  Created by yangzhenmin on 2018/6/22.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "BaseViewController.h"

@interface WeiShiSetStopViewController : BaseViewController

@property (nonatomic, strong) GizWifiDevice *dev;

@property (nonatomic, copy) VCCallBackBlock callBack;

@end