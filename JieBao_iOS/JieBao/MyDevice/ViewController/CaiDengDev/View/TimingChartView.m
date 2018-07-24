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

    LHWeakSelf(self)
    [self.shapeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(25)));
        make.top.right.equalTo(@0);
        make.bottom.equalTo(weakself.mas_bottom).offset(-CurrentDeviceSize(25));
    }];
    
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    BOOL isHad = NO;
    for (UIView *tempView in self.subviews) {
        if ([tempView isKindOfClass:[UILabel class]]) {
            isHad = YES;
            break;
        }
    }
    if (!isHad) {
        [self addYValueLabel];
        [self addXTitleLabel];
    }
}

-(void)addYValueLabel{
    
    NSArray *yValues = @[@"100%",@"75%",@"50%",@"25%"];
    for (NSInteger i = 0; i < 4 ; i++) {
        UILabel *label = [UILabel new];
        label.font = [UIFont sf_systemFontOfSize:5];
        label.textAlignment = NSTextAlignmentLeft;
        label.text = yValues[i];
        CGFloat labelX = 0 ;
        CGFloat viewHeight = (self.frame.size.height - CurrentDeviceSize(20));
        CGFloat labelY = viewHeight*i/4;
//        if (i==0) {
//            labelY = viewHeight*i/4;
//        }
        CGFloat labelW = CurrentDeviceSize(16);
        CGFloat labelH = 15;
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        [self addSubview:label];
        NSLog(@"frame = %@ labelY = %f viewH = %f",NSStringFromCGRect(self.frame),labelY,viewHeight);
        
    }
    NSLog(@"sharpeFrame = %@",NSStringFromCGRect(self.shapeView.frame));
}

-(void)addXTitleLabel{
    
    for (NSInteger i = 0; i< 25; i++) {
        UILabel *label = [UILabel new];
        label.font = [UIFont sf_systemFontOfSize:5];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = [NSString stringWithFormat:@"%ld",i];
        
        CGFloat ViewW = self.frame.size.width - CurrentDeviceSize(20) -CurrentDeviceSize(10);
        
        CGFloat tempX = ViewW * 1/24;
        
        CGFloat labelX = CurrentDeviceSize(20) + tempX *i - 15;
        
        CGFloat labelY = self.frame.size.height - CurrentDeviceSize(20) + 20;
        
        CGFloat labelW = 15;
        CGFloat labelH = 15;
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        [self addSubview:label];
    }
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


#pragma mark - getter
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
        _zeroLb.font = [UIFont sf_systemFontOfSize:6];
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
        _xMaxLb.font = [UIFont sf_systemFontOfSize:6];
        _xMaxLb.textAlignment = NSTextAlignmentRight;
        _xMaxLb.text = @"24";
    }
    return _xMaxLb;
}
@end
