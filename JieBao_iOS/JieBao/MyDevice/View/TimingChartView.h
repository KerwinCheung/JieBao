//
//  TimingChartView.h
//  JieBao
//
//  Created by yangzhenmin on 2018/5/10.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TimingChartViewDelegate<NSObject>

- (void)timingChartViewValueChange:(NSInteger)value;

@end

@interface TimingChartView : UIView

@property (nonatomic, weak) id<TimingChartViewDelegate>delegate;

- (void)setSelectedIndex:(NSInteger)index;

- (void)setChartSchValues:(NSArray<NSNumber *> *)values;

- (void)setChartOrignalValues:(NSMutableArray<NSNumber *> *)values;

- (NSArray<NSString *> *)getChartValues;

@end
