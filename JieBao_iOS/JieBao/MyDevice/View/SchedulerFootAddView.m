//
//  SchedulerFootAddView.m
//  JieBao
//
//  Created by yangzhenmin on 2018/5/8.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "SchedulerFootAddView.h"

@interface SchedulerFootAddView()

@property (nonatomic, strong) UILabel *subLb;

@property (nonatomic, strong) UIButton *btn;

@property (nonatomic, strong) UIView *bgView;

@end

@implementation SchedulerFootAddView

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
    [self addSubview:self.bgView];
    [self addSubview:self.subLb];
    [self addSubview:self.btn];
    
    LHWeakSelf(self)
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakself).insets(UIEdgeInsetsZero);
    }];
    
    [self.subLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.centerY.equalTo(weakself.mas_centerY);
        make.width.lessThanOrEqualTo(@200);
    }];
    
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakself.mas_centerY);
        make.right.equalTo(weakself.mas_right).offset(-CurrentDeviceSize(20));
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(30), CurrentDeviceSize(30)));
    }];
}

- (void)btnClicked
{
    if (_delegate && [_delegate respondsToSelector:@selector(addScheduleClicked)]) {
        [_delegate addScheduleClicked];
    }
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (UILabel *)subLb
{
    if (!_subLb) {
        _subLb = [UILabel new];
        _subLb.font = [UIFont sf_systemFontOfSize:13];
        _subLb.text = @"添加定时程序";
    }
    return _subLb;
}

- (UIButton *)btn
{
    if (!_btn) {
        _btn = [UIButton new];
        [_btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_btn setImage:[UIImage imageNamed:@"tianji1"] forState:UIControlStateNormal];
    }
    return _btn;
}
@end
