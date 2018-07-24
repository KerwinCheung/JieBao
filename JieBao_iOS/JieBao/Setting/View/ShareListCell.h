//
//  ShareListCell.h
//  JieBao
//
//  Created by yangzhenmin on 2018/4/18.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShareModel.h"

@interface ShareListCell : UITableViewCell

@property (nonatomic, strong) ShareModel *shareModel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *devNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *macLabel;

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIImageView *shortLine;
@property (weak, nonatomic) IBOutlet UIImageView *longLine;

@end
