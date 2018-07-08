//
//  SliderView.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/23.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "SliderView.h"

@interface SliderView()

@property (nonatomic, strong) UIView *sliderBGView;

@property (nonatomic, strong) UILabel *settingNameLb;

@property (nonatomic, strong) UILabel *valuelb;

@property (nonatomic, strong) BaseSlider *slider;

@end

@implementation SliderView

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
    [self addSubview:self.sliderBGView];
    [self.sliderBGView addSubview:self.settingNameLb];
    [self.sliderBGView addSubview:self.valuelb];
    [self.sliderBGView addSubview:self.slider];
    
    [self makeContraints];
}

- (void)makeContraints
{
    LHWeakSelf(self)
    
    [self.sliderBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakself).insets(UIEdgeInsetsZero);
    }];
    
    [self.settingNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.top.equalTo(@(CurrentDeviceSize(20)));
        make.width.lessThanOrEqualTo(@200);
    }];
    
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.settingNameLb.mas_left);
        make.top.equalTo(weakself.settingNameLb.mas_bottom).offset(CurrentDeviceSize(5));
        make.height.equalTo(@(CurrentDeviceSize(10)));
        make.right.equalTo(weakself.mas_right).offset(-CurrentDeviceSize(20));
    }];
    
    [self.valuelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(CurrentDeviceSize(20)));
        make.width.lessThanOrEqualTo(@200);
        make.right.equalTo(weakself.slider.mas_right);
    }];
}

- (void)setTrickColor:(UIColor *)color
{
    self.slider.minimumTrackTintColor = color;
}

- (void)setTrickImg:(NSString *)img
{
    [self.slider setMinimumTrackImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
}

- (void)sliderValueChanged:(BaseSlider *)slider
{
    self.valuelb.text = [NSString stringWithFormat:@"%ld%%",(NSInteger)self.slider.value];
}

- (UIView *)sliderBGView
{
    if (!_sliderBGView) {
        _sliderBGView = [UIView new];
        _sliderBGView.backgroundColor = [UIColor whiteColor];
    }
    return _sliderBGView;
}

- (UILabel *)valuelb
{
    if (!_valuelb) {
        _valuelb = [UILabel new];
        _valuelb.font = [UIFont sf_systemFontOfSize:12];
        _valuelb.text = @"0.0%";
    }
    return _valuelb;
}

- (UILabel *)settingNameLb
{
    if (!_settingNameLb) {
        _settingNameLb = [UILabel new];
        _settingNameLb.font = [UIFont sf_systemFontOfSize:12];
        _settingNameLb.text = @"亮度";
    }
    return _settingNameLb;
}

- (BaseSlider *)slider
{
    if (!_slider) {
        _slider = [BaseSlider new];
        _slider.minimumValue = 0;
        _slider.maximumValue = 100;
        [_slider setThumbImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
        [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}

- (CGFloat)value
{
    return self.slider.value;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.settingNameLb.text = title;
}
@end
