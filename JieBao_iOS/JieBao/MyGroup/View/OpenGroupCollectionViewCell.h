//
//  OpenGroupCollectionViewCell.h
//  JieBao
//
//  Created by yangzhenmin on 2018/6/7.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "BaseCollectionViewCell.h"
#import "CustomDevice.h"

@class OpenGroupCollectionViewCell;
@protocol OpenGroupCollectionViewCellDelegate<NSObject>

-(void)OpenGroupCollectionViewCell:(OpenGroupCollectionViewCell *)cell longTapWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface OpenGroupCollectionViewCell : BaseCollectionViewCell

@property (nonatomic, strong) CustomDevice *customDev;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<OpenGroupCollectionViewCellDelegate>delegate;

-(void)setCellStatus:(BOOL)isStatus;
-(void)setCellNoConnected;
- (BOOL)isSwitchOn;

@end
