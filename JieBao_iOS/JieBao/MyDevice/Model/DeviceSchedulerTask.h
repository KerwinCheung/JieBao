//
//  DeviceSchedulerTask.h
//  JieBao
//
//  Created by yangzhenmin on 2018/5/24.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceCommonSchulder.h"

@interface DeviceSchedulerTask : NSObject

@property (nonatomic, copy) NSString *taskName;

@property (nonatomic, strong) NSArray<DeviceCommonSchulder *> *sches;

@property (nonatomic, copy) NSString *taskLogo;


- (void)setTempLpsSches;
- (void)setTempSpsSches;
@end
