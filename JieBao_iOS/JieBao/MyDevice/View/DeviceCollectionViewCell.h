//
//  DeviceCollectionViewCell.h
//  JieBao
//
//  Created by yangzhenmin on 2018/6/6.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "BaseCollectionViewCell.h"

@class DeviceCollectionViewCell;
@protocol DeviceCollectionViewCellDelegate<NSObject>

-(void)DeviceCollectionViewCell:(DeviceCollectionViewCell *)cell longTapWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface DeviceCollectionViewCell : BaseCollectionViewCell

@property (nonatomic, strong) GizWifiDevice *dataDic;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, weak) id<DeviceCollectionViewCellDelegate>delegate;

- (void)cellSetSelected;

- (BOOL)isSwitchOn;

- (void)cellSetSelectedWithStatus:(BOOL)selected;
@end
