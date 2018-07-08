//
//  CaiDengTimingAddCell.h
//  JieBao
//
//  Created by yangzhenmin on 2018/4/23.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CaiDengTimingAddCellDelegate<NSObject>

- (void)addSchBtnClicked;

@end

@interface CaiDengTimingAddCell : UITableViewCell

@property (nonatomic, weak) id<CaiDengTimingAddCellDelegate>delegate;

@end
