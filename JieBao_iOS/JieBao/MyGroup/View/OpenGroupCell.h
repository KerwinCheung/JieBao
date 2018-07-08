//
//  OpenGroupCell.h
//  JieBao
//
//  Created by yangzhenmin on 2018/4/13.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomDevice.h"

@interface OpenGroupCell : UITableViewCell

@property (nonatomic, strong) NSArray<CustomDevice *> *dataSource;

@end
