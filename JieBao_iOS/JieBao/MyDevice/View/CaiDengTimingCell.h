//
//  CaiDengTimingCell.h
//  JieBao
//
//  Created by yangzhenmin on 2018/4/23.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceSchedulerTask.h"

@interface CaiDengTimingCell : UITableViewCell

@property (nonatomic, strong) DeviceSchedulerTask *dataDic;

@property (nonatomic, assign) BOOL isEdit;

- (void)setSelectedWithStutas:(BOOL)status;

- (void)setSelected;

- (BOOL)getSelected;


@end
