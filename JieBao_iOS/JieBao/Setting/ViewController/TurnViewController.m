//
//  TurnViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/17.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "TurnViewController.h"

@interface TurnViewController ()

@property (nonatomic, strong) UIButton *turnBtn;

@property (nonatomic, strong) UIImageView *btnsView;

@property (nonatomic, strong) UIView *btnsBGView;

@property (nonatomic, strong) UIButton *appConBtn;

@property (nonatomic, strong) UILabel *msgLb;

@property (nonatomic, strong) UIButton *ch1Btn;

@property (nonatomic, strong) UIButton *ch2Btn;

@property (nonatomic, strong) UIButton *ch3Btn;

@property (nonatomic, strong) UIButton *ch4Btn;

@end

@implementation TurnViewController

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UICOLORFROMRGB(0xededed);
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    LHWeakSelf(self)
    ActionBlock leftAction = ^(UIButton *btn){
        [weakself.navigationController popViewControllerAnimated:YES];
        LHLog(@"left");
    };
    [self.naviBar  configNavigationBarWithAttrs:@{
                                                  kCustomNaviBarLeftActionKey:leftAction,
                                                  kCustomNaviBarLeftImgKey:@"back",
                                                  kCustomNaviBarTitleKey:@"无线开关",
                                                  }];
}

- (void)initUI
{
    [self.view addSubview:self.turnBtn];
    [self.view addSubview:self.btnsBGView];
    [self.btnsBGView addSubview:self.btnsView];
    [self.btnsView addSubview:self.ch1Btn];
    [self.btnsView addSubview:self.ch2Btn];
    [self.btnsView addSubview:self.ch3Btn];
    [self.btnsView addSubview:self.ch4Btn];
    [self.btnsBGView addSubview:self.appConBtn];
    [self.btnsBGView addSubview:self.msgLb];
    
    self.ch1Btn.backgroundColor = self.ch2Btn.backgroundColor = self.ch3Btn.backgroundColor=self.ch4Btn.backgroundColor = [UIColor redColor];
    LHWeakSelf(self)
    [self.turnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(LL_ScreenHeight/3 - CurrentDeviceSize(40),LL_ScreenHeight/3 - CurrentDeviceSize(40)));
        make.top.equalTo(@(LL_StatusBarAndNavigationBarHeight + CurrentDeviceSize(20)));
    }];
    
    [self.btnsBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.top.equalTo(weakself.turnBtn.mas_bottom).offset(CurrentDeviceSize(20));
    }];
    
    [self.btnsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.size.equalTo(weakself.turnBtn);
        make.top.equalTo(@(CurrentDeviceSize(20)));
    }];
    
    [self.ch1Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakself.btnsView.mas_width).multipliedBy(0.5);
        make.height.equalTo(weakself.btnsView.mas_height).multipliedBy(0.25);
        make.centerX.equalTo(weakself.btnsView.mas_centerX);
        make.top.equalTo(@(CurrentDeviceSize(5)));
    }];
    
    [self.ch3Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakself.ch1Btn);
        make.centerX.equalTo(weakself.btnsView.mas_centerX);
        make.bottom.equalTo(weakself.btnsView.mas_bottom).offset(-CurrentDeviceSize(5));
    }];
    
    [self.ch4Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(weakself.btnsView.mas_width).multipliedBy(0.25);
        make.height.equalTo(weakself.btnsView.mas_height).multipliedBy(0.5);
        make.centerY.equalTo(weakself.btnsView.mas_centerY);
        make.left.equalTo(@(CurrentDeviceSize(5)));
    }];
    
    [self.ch2Btn mas_makeConstraints:^(MASConstraintMaker *make) {
         make.size.equalTo(weakself.ch4Btn);
        make.centerY.equalTo(weakself.btnsView.mas_centerY);
        make.right.equalTo(weakself.btnsView.mas_right).offset(-CurrentDeviceSize(5));
    }];
    
    [self.appConBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.size.equalTo(weakself.ch1Btn);
        make.top.equalTo(weakself.btnsView.mas_bottom).offset(CurrentDeviceSize(30));
    }];
    
    [self.msgLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.top.equalTo(weakself.appConBtn.mas_bottom).offset(CurrentDeviceSize(30));
        make.width.lessThanOrEqualTo(@(CurrentDeviceSize(200)));
    }];
}

- (void)turnBtnClicked
{
    LHLog(@"open");
}

-  (void)appConBtnClicked
{
    LHLog(@"appConBtnClicked");
}

- (void)ch1BtnClicked
{
    LHLog(@"ch1BtnClicked");
}

- (void)ch2BtnClicked
{
    LHLog(@"ch2BtnClicked");
}

- (void)ch3BtnClicked
{
    LHLog(@"ch3BtnClicked");
}


- (void)ch4BtnClicked
{
    LHLog(@"ch4BtnClicked");
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.navigationController pushViewController:[NSClassFromString(@"WIFIControlViewController") new] animated:YES];
}

- (UIButton *)turnBtn
{
    if (!_turnBtn) {
        _turnBtn = [UIButton new];
        [_turnBtn addTarget:self action:@selector(turnBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_turnBtn setImage:[UIImage imageNamed:@"wuxiankaiguan_open"] forState:UIControlStateNormal];
    }
    return _turnBtn;
}

- (UIImageView *)btnsView
{
    if (!_btnsView) {
        _btnsView = [UIImageView new];
        _btnsView.image = [UIImage imageNamed:@"wuxiankauguan_anniu"];
    }
    return _btnsView;
}

- (UIView *)btnsBGView
{
    if (!_btnsBGView) {
        _btnsBGView = [UIView new];
        _btnsBGView.backgroundColor = [UIColor whiteColor];
    }
    return _btnsBGView;
}

- (UIButton *)appConBtn
{
    if (!_appConBtn) {
        _appConBtn = [UIButton new];
        [_appConBtn setImage:[UIImage imageNamed:@"app"] forState:UIControlStateNormal];
        [_appConBtn addTarget:self action:@selector(appConBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _appConBtn;
}

- (UILabel *)msgLb
{
    if (!_msgLb) {
        _msgLb = [UILabel new];
        _msgLb.font = [UIFont  sf_systemFontOfSize:12];
        _msgLb.text = @"提示:长按进入开关设置";
    }
    return _msgLb;
}

- (UIButton *)ch1Btn
{
    if (!_ch1Btn) {
        _ch1Btn = [UIButton new];
        [_ch1Btn addTarget:self action:@selector(ch1BtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ch1Btn;
}

- (UIButton *)ch2Btn
{
    if (!_ch2Btn) {
        _ch2Btn = [UIButton new];
        [_ch2Btn addTarget:self action:@selector(ch2BtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ch2Btn;
}

- (UIButton *)ch3Btn
{
    if (!_ch3Btn) {
        _ch3Btn = [UIButton new];
        [_ch3Btn addTarget:self action:@selector(ch3BtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ch3Btn;
}

- (UIButton *)ch4Btn
{
    if (!_ch4Btn) {
        _ch4Btn = [UIButton new];
        [_ch4Btn addTarget:self action:@selector(ch4BtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ch4Btn;
}
@end
