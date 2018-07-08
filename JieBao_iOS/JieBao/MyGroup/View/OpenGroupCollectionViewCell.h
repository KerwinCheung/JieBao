//
//  OpenGroupCollectionViewCell.h
//  JieBao
//
//  Created by yangzhenmin on 2018/6/7.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "BaseCollectionViewCell.h"
#import "CustomDevice.h"

@interface OpenGroupCollectionViewCell : BaseCollectionViewCell

@property (nonatomic, strong) CustomDevice *dataDic;

- (void)cellSetSelected;

- (BOOL)isSwitchOn;

@end
