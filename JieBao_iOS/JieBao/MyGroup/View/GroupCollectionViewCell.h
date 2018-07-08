//
//  GroupCollectionViewCell.h
//  JieBao
//
//  Created by yangzhenmin on 2018/6/6.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "BaseCollectionViewCell.h"
#import "CustomDeviceGroup.h"

@interface GroupCollectionViewCell : BaseCollectionViewCell

@property (nonatomic, strong) CustomDeviceGroup *dataDic;

- (void)cellSetSelected;

- (BOOL)isSwitchOn;

@end
