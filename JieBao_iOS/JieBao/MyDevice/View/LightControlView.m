//
//  LightControlView.m
//  JieBao
//
//  Created by yangzhenmin on 2018/5/9.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "LightControlView.h"

@interface LightControlView()

@property (nonatomic, strong) UIButton *btn;

@property (nonatomic, strong) UILabel *textLb;

@end

@implementation LightControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame: frame]) {
        self.layer.masksToBounds = YES;
        [self initUI];
    }
    return self;
}


- (void)initUI
{
    [self addSubview:self.btn];
    [self addSubview:self.textLb];
    
    LHWeakSelf(self)
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(4)));
        make.centerY.equalTo(weakself.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(10), CurrentDeviceSize(10)));
    }];
    
    [self.textLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakself.btn);
        make.left.equalTo(weakself.btn.mas_right).offset(CurrentDeviceSize(2));
        make.width.lessThanOrEqualTo(@200);
    }];
}

- (void)btnClicked
{
    self.isClicked = !self.isClicked;
    if (_delegate && [_delegate respondsToSelector:@selector(colorBlockClicked:)]) {
        [_delegate colorBlockClicked:self];
    }
}

- (void)setIsClicked:(BOOL)isClicked
{
    _isClicked = isClicked;
    self.textLb.font = [UIFont sf_systemFontOfSize:8];
    if (_isClicked) {
        [self.btn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(14), CurrentDeviceSize(14)));
        }];
        self.btn.layer.cornerRadius = CurrentDeviceSize(7);
    }
    else
    {
        [self.btn mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(10), CurrentDeviceSize(10)));
        }];
        self.btn.layer.cornerRadius = CurrentDeviceSize(5);
    }
    
    [self setNeedsLayout];
}

- (UIButton *)btn
{
    if (!_btn) {
        _btn = [UIButton new];
        [_btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
        _btn.layer.masksToBounds = YES;
        _btn.layer.cornerRadius = CurrentDeviceSize(5);
        _btn.layer.borderWidth = 0.5;
        _btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    }
    return _btn;
}

- (UILabel *)textLb
{
    if (!_textLb) {
        _textLb = [UILabel new];
        _textLb.font = [UIFont sf_systemFontOfSize:8];
        _textLb.textAlignment = NSTextAlignmentLeft;
        _textLb.text = @"50%";
    }
    return _textLb;
}

- (void)setBtnColor:(UIColor *)btnColor
{
    self.btn.backgroundColor = btnColor;
}

- (void)setValue:(NSInteger)value
{
    _value = value;
    self.textLb.text = [NSString stringWithFormat:@"%ld%%",value];
}
@end
