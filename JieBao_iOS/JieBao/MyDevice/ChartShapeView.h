//
//  ChartShapeView.h
//  JieBao
//
//  Created by yangzhenmin on 2018/5/10.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChartShapeView : UIView

@property (nonatomic, strong) NSMutableArray<NSNumber *> *schValues;

- (void)setTrackAndLineColorWithIndex:(NSInteger)index;

- (void)setOrignalValues:(NSMutableArray<NSNumber *> *)values;

@end
