//
//  ShuiBengTimingCell.h
//  JieBao
//
//  Created by yangzhenmin on 2018/6/22.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceSchedulerTask.h"

@interface ShuiBengTimingCell : UITableViewCell

@property (nonatomic, strong) DeviceSchedulerTask *dataDic;

- (void)setSelected;

- (BOOL)getSelected;


@end
