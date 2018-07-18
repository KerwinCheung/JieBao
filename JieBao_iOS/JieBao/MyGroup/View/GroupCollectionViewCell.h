//
//  GroupCollectionViewCell.h
//  JieBao
//
//  Created by wen on 2018/6/6.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "BaseCollectionViewCell.h"
#import "CustomDeviceGroup.h"

@class GroupCollectionViewCell;
@protocol GroupCollectionViewCellCellDelegate<NSObject>

-(void)GroupCollectionViewCellCell:(GroupCollectionViewCell *)cell longTapWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface GroupCollectionViewCell : BaseCollectionViewCell

@property (nonatomic, strong) CustomDeviceGroup *group;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, weak) id<GroupCollectionViewCellCellDelegate>delegate;

- (void)cellSetSelected;
-(void)setCellStatus:(BOOL)isStatus;
- (BOOL)isSwitchOn;

@end
