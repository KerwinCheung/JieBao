//
//  EditGroupCell.h
//  JieBao
//
//  Created by yangzhenmin on 2018/4/14.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditAddGroupCell : UITableViewCell

@property (nonatomic, strong) GizWifiDevice *dataDic;

- (void)setSelected;

- (BOOL)getSelected;

@end
