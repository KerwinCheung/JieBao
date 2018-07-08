//
//  BaseCustomNavigationBarView.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/16.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "BaseCustomNavigationBarView.h"

@interface BaseCustomNavigationBarView()

@property (nonatomic, strong) UIButton *leftBtn;

@property (nonatomic, strong) UILabel *leftTitleLb;

@property (nonatomic, strong) UIButton *rightBtn;

@property (nonatomic, strong) UIView *sepLine;

@property (nonatomic, strong) UILabel *titleLb;

@property (nonatomic, copy) ActionBlock leftBlock;

@property (nonatomic, copy) ActionBlock rightBlock;

@end

@implementation BaseCustomNavigationBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.masksToBounds = YES;
        self.backgroundColor = UICOLORFROMRGB(0xffffff);
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    [self addSubview:self.leftBtn];
    [self addSubview:self.rightBtn];
    [self addSubview:self.titleLb];
    [self addSubview:self.leftTitleLb];
    [self addSubview:self.sepLine];
    
    LHWeakSelf(self)
    [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.centerY.equalTo(weakself.mas_centerY).offset(CurrentDeviceSize(15));
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.mas_right).offset(-CurrentDeviceSize(20));
        make.centerY.equalTo(weakself.mas_centerY).offset(CurrentDeviceSize(15));
        make.size.mas_equalTo(CGSizeMake(40, 30));
    }];
    
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.mas_centerX);
        make.centerY.equalTo(weakself.mas_centerY).offset(CurrentDeviceSize(10));
        make.width.lessThanOrEqualTo(@(CurrentDeviceSize(200)));
    }];
    
    [self.leftTitleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.leftBtn).offset(CurrentDeviceSize(5));
        make.centerY.equalTo(weakself.leftBtn.mas_centerY);
        make.width.lessThanOrEqualTo(@(CurrentDeviceSize(200)));
    }];
    
    [self.sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@(CurrentDeviceSize(0.5)));
    }];
}


- (void)configNavigationBarWithAttrs:(NSDictionary *)attrs
{
    UIImage *leftImg = [UIImage imageNamed:attrs[kCustomNaviBarLeftImgKey]?attrs[kCustomNaviBarLeftImgKey]:@""];
    if (!leftImg) {
        [self.leftBtn setTitle:attrs[kCustomNaviBarLeftImgKey]?attrs[kCustomNaviBarLeftImgKey]:@"" forState:UIControlStateNormal];
    }else
    {
         [self.leftBtn setImage:leftImg forState:UIControlStateNormal];
    }
    
    UIImage *rightImg = [UIImage imageNamed:attrs[kCustomNaviBarRightImgKey]?attrs[kCustomNaviBarRightImgKey]:@""];
    if (!rightImg) {
        [self.rightBtn setTitle:attrs[kCustomNaviBarRightImgKey]?attrs[kCustomNaviBarRightImgKey]:@"" forState:UIControlStateNormal];
    }else
    {
        [self.rightBtn setImage:rightImg forState:UIControlStateNormal];
        [self.rightBtn sizeToFit];
    }
    
    [self.leftTitleLb setText:attrs[kCustomNaviBarLeftTextKey]];
    [self.titleLb setText:attrs[kCustomNaviBarTitleKey]];
    
    self.leftBlock = attrs[kCustomNaviBarLeftActionKey]?attrs[kCustomNaviBarLeftActionKey]:nil;
    self.rightBlock = attrs[kCustomNaviBarRightActionKey]?attrs[kCustomNaviBarRightActionKey]:nil;
}

- (void)configRightBtnWithAttrs:(NSDictionary *)attrs
{
    UIImage *rightImg = [UIImage imageNamed:attrs[kCustomNaviBarRightImgKey]?attrs[kCustomNaviBarRightImgKey]:@""];
    if (!rightImg) {
        [self.rightBtn setTitle:attrs[kCustomNaviBarRightImgKey]?attrs[kCustomNaviBarRightImgKey]:@"" forState:UIControlStateNormal];
    }else
    {
        [self.rightBtn setImage:rightImg forState:UIControlStateNormal];
    }
    self.rightBlock = attrs[kCustomNaviBarRightActionKey]?attrs[kCustomNaviBarRightActionKey]:nil;
}

- (void)leftBtnClicked:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (self.leftBlock) {
        self.leftBlock(btn);
    }
}

- (void)rightBtnClicked:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if (self.rightBlock) {
        self.rightBlock(btn);
    }
}


- (UIButton *)leftBtn
{
    if (!_leftBtn) {
        _leftBtn = [UIButton new];
        [_leftBtn addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_leftBtn setTitleColor:kAPPThemeColor forState:UIControlStateNormal];
        [_leftBtn.titleLabel setFont:[UIFont sf_systemFontOfSize:14]];
    }
    return  _leftBtn;
}

- (UIButton *)rightBtn
{
    if (!_rightBtn) {
        _rightBtn = [UIButton new];
        [_rightBtn addTarget:self action:@selector(rightBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn setTitleColor:kAPPThemeColor forState:UIControlStateNormal];
        [_rightBtn.titleLabel setFont:[UIFont sf_systemFontOfSize:14]];
    }
    return  _rightBtn;
}

- (UILabel *)titleLb
{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.font = [UIFont sf_systemFontOfSize:16];
    }
    return _titleLb;
}

- (UILabel *)leftTitleLb
{
    if (!_leftTitleLb) {
        _leftTitleLb = [UILabel new];
        _leftTitleLb.font = [UIFont sf_systemFontOfSize:13];
    }
    return _leftTitleLb;
}

- (UIView *)sepLine
{
    if (!_sepLine) {
        _sepLine = [UIView new];
        _sepLine.backgroundColor = UICOLORFROMRGB(0xf0f0f0);
    }
    return _sepLine;
}
- (void)setTitle:(NSString *)title
{
    self.titleLb.text = title;
}
@end
