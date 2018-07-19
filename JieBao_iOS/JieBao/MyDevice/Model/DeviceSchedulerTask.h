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

/**一个彩灯定时有24个平台定时任务**/
@property (nonatomic, strong) NSArray<DeviceCommonSchulder *> *sches;

@property (nonatomic, copy) NSString *taskLogo;

/**是否默认程序*/
@property (assign, nonatomic) BOOL isDeafult;


- (void)setTempLpsSches;
- (void)setTempSpsSches;
@end
