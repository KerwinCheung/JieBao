//
//  WeiShiCell.h
//  JieBao
//
//  Created by yangzhenmin on 2018/5/18.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WeiShiCellDelegate<NSObject>

- (void)transfer;

@end

@interface WeiShiCell : UITableViewCell

@property (nonatomic, weak) id<WeiShiCellDelegate>delegate;

@end
