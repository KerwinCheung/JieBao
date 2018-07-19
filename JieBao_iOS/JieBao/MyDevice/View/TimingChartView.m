//
//  TimingChartView.m
//  JieBao
//
//  Created by yangzhenmin on 2018/5/10.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "TimingChartView.h"
#import "ChartShapeView.h"

@interface TimingChartView()<ChartShapeViewDelegate>

@property (nonatomic, strong) ChartShapeView *shapeView;

@property (nonatomic, strong) UILabel *zeroLb;

@property (nonatomic, strong) UILabel *yMaxLb;

@property (nonatomic, strong) UILabel *xMaxLb;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat height;

@end

@implementation TimingChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.masksToBounds = YES;
        [self initUI];
    }
    return self;
}


- (void)initUI
{
    [self addSubview:self.shapeView];
    [self addSubview:self.zeroLb];
    [self addSubview:self.yMaxLb];
    [self addSubview:self.xMaxLb];
    
    LHWeakSelf(self)
    [self.shapeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.top.right.equalTo(@0);
        make.bottom.equalTo(weakself.mas_bottom).offset(-CurrentDeviceSize(20));
    }];
    
    [self.zeroLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.shapeView.mas_left);
        make.bottom.equalTo(@0);
        make.width.lessThanOrEqualTo(@50);
    }];
    
    [self.xMaxLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.shapeView).offset(-CurrentDeviceSize(20));
        make.bottom.equalTo(@0);
        make.width.lessThanOrEqualTo(@50);
    }];
    
    [self.yMaxLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.shapeView.mas_left);
        make.top.equalTo(@0);
        make.width.lessThanOrEqualTo(@50);
    }];
}

- (void)setSelectedIndex:(NSInteger)index
{
    [self.shapeView setTrackAndLineColorWithIndex:index];
}

- (void)setChartSchValues:(NSArray<NSNumber *> *)values
{
    self.shapeView.schValues = values;
}

- (void)setChartOrignalValues:(NSMutableArray<NSNumber *> *)values
{
    [self.shapeView setOrignalValues:values];
}

- (NSArray<NSString *> *)getChartValues
{
    return self.shapeView.schValues;
}

- (void)chartShapeViewValueChange:(NSInteger)value
{
    if (_delegate && [_delegate respondsToSelector:@selector(timingChartViewValueChange:)]) {
        [_delegate timingChartViewValueChange:value];
    }
}

- (ChartShapeView *)shapeView
{
    if (!_shapeView) {
        _shapeView = [ChartShapeView new];
        _shapeView.delegate = self;
    }
    return _shapeView;
}

- (UILabel *)zeroLb
{
    if (!_zeroLb) {
        _zeroLb = [UILabel new];
        _zeroLb.font = [UIFont sf_systemFontOfSize:8];
        _zeroLb.textAlignment = NSTextAlignmentRight;
        _zeroLb.text = @"0";
    }
    return _zeroLb;
}

- (UILabel *)yMaxLb
{
    if (!_yMaxLb) {
        _yMaxLb = [UILabel new];
        _yMaxLb.font = [UIFont sf_systemFontOfSize:8];
        _yMaxLb.textAlignment = NSTextAlignmentRight;
        _yMaxLb.text = @"100%";
    }
    return _yMaxLb;
}

- (UILabel *)xMaxLb
{
    if (!_xMaxLb) {
        _xMaxLb = [UILabel new];
        _xMaxLb.font = [UIFont sf_systemFontOfSize:8];
        _xMaxLb.textAlignment = NSTextAlignmentRight;
        _xMaxLb.text = @"24";
    }
    return _xMaxLb;
}
@end
