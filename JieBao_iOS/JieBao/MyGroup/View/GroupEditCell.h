//
//  GroupEditCell.h
//  JieBao
//
//  Created by yangzhenmin on 2018/6/5.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomDevice.h"
@interface GroupEditCell : UITableViewCell

@property (nonatomic, strong) CustomDevice *dataDic;

- (void)setSelected;

- (BOOL)getSelected;


@end
