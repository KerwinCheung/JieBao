//
//  MyDeviceNoDeviceView.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/27.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "MyDeviceNoDeviceView.h"

@interface MyDeviceNoDeviceView()

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *tipLb;

@property (nonatomic, strong) UIButton *btn;

@end

@implementation MyDeviceNoDeviceView

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
    [self addSubview:self.imgView];
    [self addSubview:self.tipLb];
    [self addSubview:self.btn];
    
    LHWeakSelf(self)
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(120), CurrentDeviceSize(120)));
        make.top.equalTo(@(CurrentDeviceSize(60)));
    }];
    
    [self.tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.mas_centerX);
        make.width.lessThanOrEqualTo(@200);
        make.top.equalTo(weakself.imgView.mas_bottom).offset(CurrentDeviceSize(20));
    }];
    
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.mas_centerX);
        make.top.equalTo(weakself.tipLb.mas_bottom).offset(CurrentDeviceSize(40));
        make.height.equalTo(@(CurrentDeviceSize(40)));
        make.width.equalTo(@(LL_ScreenWidth - CurrentDeviceSize(80)));
    }];
}

- (void)btnClicked
{
    if (_delegate && [_delegate respondsToSelector:@selector(addBtnClicked)]) {
        [_delegate addBtnClicked];
    }
}

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [UIImageView new];
        _imgView.image = [UIImage imageNamed:@"wu"];
    }
    return _imgView;
}

- (UILabel *)tipLb
{
    if (!_tipLb) {
        _tipLb = [UILabel new];
        _tipLb.font = [UIFont sf_systemFontOfSize:15];
        _tipLb.text = @"暂无设备";
        _tipLb.textAlignment = NSTextAlignmentCenter;
    }
    return _tipLb;
}

- (UIButton *)btn
{
    if (!_btn) {
        _btn = [UIButton new];
        [_btn setBackgroundImage:[UIImage imageNamed:@"btnBg"] forState:UIControlStateNormal];
        [_btn.titleLabel setTextColor:[UIColor whiteColor]];
        [_btn setTitle:@"立即添加" forState:UIControlStateNormal];
        _btn.layer.masksToBounds = YES;
        _btn.layer.cornerRadius = CurrentDeviceSize(5);
        [_btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}
@end
