//
//  SettingHeadView.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/12.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "SettingHeadView.h"

@interface SettingHeadView()

@property (nonatomic, strong) UIImageView *bgImgView;

@property (nonatomic, strong) UILabel *headLb;

@property (nonatomic, strong) UIImageView *headImgView;

@property (nonatomic, strong) UILabel *usrLb;

@end

@implementation SettingHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.masksToBounds = YES;
        [self iniUI];
    }
    return self;
}

- (void)iniUI
{
    [self addSubview:self.bgImgView];
    [self addSubview:self.headLb];
    [self addSubview:self.headImgView];
    [self addSubview:self.usrLb];
    
    [self makeContraints];
}

- (void)makeContraints
{
    LHWeakSelf(self)
    [self.bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakself).insets(UIEdgeInsetsZero);
    }];
    
    [self.headLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.mas_centerX);
        make.top.equalTo(@(LL_StatusBarHeight));
        make.width.lessThanOrEqualTo(@100);
    }];
    
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.mas_centerX);
        make.top.equalTo(weakself.headLb.mas_bottom).offset(CurrentDeviceSize(10));
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(80),CurrentDeviceSize(80)));
    }];
    
    [self.usrLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.mas_centerX);
        make.top.equalTo(weakself.headImgView.mas_bottom).offset(CurrentDeviceSize(10));
        make.width.lessThanOrEqualTo(@100);
    }];
}

- (void)headImgViewTap
{
    if (self.currentUser) return;
    if (_delegate && [_delegate respondsToSelector:@selector(headImgTap)]) {
        [_delegate headImgTap];
    }
}

- (UIImageView *)bgImgView
{
    if (!_bgImgView) {
        _bgImgView = [UIImageView new];
        _bgImgView.image = [UIImage imageNamed:@"back_gloun"];
    }
    return _bgImgView;
}

- (UILabel *)headLb
{
    if (!_headLb) {
        _headLb = [UILabel new];
        _headLb.font = [UIFont sf_systemFontOfSize:15];
        _headLb.textAlignment = NSTextAlignmentCenter;
        _headLb.text = @"设置";
    }
    return _headLb;
}

- (UIImageView *)headImgView
{
    if (!_headImgView) {
        _headImgView = [[UIImageView alloc]init];
        _headImgView.layer.masksToBounds = YES;
        _headImgView.layer.cornerRadius = CurrentDeviceSize(10);
        _headImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImgViewTap)];
        [_headImgView addGestureRecognizer:tap];
    }
    return _headImgView;
}

- (UILabel *)usrLb
{
    if (!_usrLb) {
        _usrLb = [[UILabel alloc]init];
        _usrLb.font = [UIFont sf_systemFontOfSize:13];
        _usrLb.textAlignment = NSTextAlignmentCenter;
    }
    return _usrLb;
}

- (void)setCurrentUser:(UserModel *)currentUser
{
    _currentUser = currentUser;
    self.headImgView.image = [UIImage imageNamed:@"head"];
    self.usrLb.text = currentUser.userName;
}
@end
