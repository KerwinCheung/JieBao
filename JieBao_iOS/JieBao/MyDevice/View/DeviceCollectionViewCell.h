//
//  DeviceCollectionViewCell.h
//  JieBao
//
//  Created by yangzhenmin on 2018/6/6.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@interface DeviceCollectionViewCell : BaseCollectionViewCell

@property (nonatomic, strong) GizWifiDevice *dataDic;

- (void)cellSetSelected;

- (BOOL)isSwitchOn;

- (void)cellSetSelectedWithStatus:(BOOL)selected;
@end
