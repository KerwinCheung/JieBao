//
//  ChannelDetailCell.h
//  JieBao
//
//  Created by yangzhenmin on 2018/5/14.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChannelDetailCellDelegate<NSObject>

- (void)tranferToSetChannelTime;

@end

@interface ChannelDetailCell : UITableViewCell

@property (nonatomic, strong) GizDeviceScheduler *dataDic;

@property (nonatomic, weak) id<ChannelDetailCellDelegate>delegate;

@end
