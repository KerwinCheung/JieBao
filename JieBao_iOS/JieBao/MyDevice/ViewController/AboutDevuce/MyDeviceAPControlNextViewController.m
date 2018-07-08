//
//  APNextViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/17.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "MyDeviceAPControlNextViewController.h"

@interface MyDeviceAPControlNextViewController ()

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *textLb;

@property (nonatomic, strong) UIButton *settingBtn;

@property (nonatomic, strong) UIView *wifiBgView;

@property (nonatomic, strong) UILabel *wifiNameLb;

@property (nonatomic, strong) UIButton *wifiTranferBtn;

@end

@implementation MyDeviceAPControlNextViewController

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
                                                  kCustomNaviBarTitleKey:@"AP控制",
                                                  }];
}

- (void)initUI
{
    [self.view addSubview:self.imgView];
    [self.view addSubview:self.textLb];
    [self.view addSubview:self.settingBtn];
    [self.view addSubview:self.wifiBgView];
    [self.wifiBgView addSubview:self.wifiNameLb];
    [self.wifiBgView addSubview:self.wifiTranferBtn];
    
    LHWeakSelf(self)
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(220), CurrentDeviceSize(160)));
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.height.equalTo(@(CurrentDeviceSize(100)));
        make.top.equalTo(@(LL_StatusBarAndNavigationBarHeight + CurrentDeviceSize(20)));
    }];
    
    [self.textLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.width.lessThanOrEqualTo(@(CurrentDeviceSize(200)));
        make.top.equalTo(weakself.imgView.mas_bottom).offset(CurrentDeviceSize(30));
    }];
    
    
    [self.settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.width.equalTo(weakself.imgView.mas_width);
        make.height.equalTo(@(CurrentDeviceSize(35)));
        make.bottom.equalTo(weakself.view.mas_bottom).offset(-CurrentDeviceSize(100));
    }];
    
    [self.wifiBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@(CurrentDeviceSize(40)));
        make.top.equalTo(weakself.textLb.mas_bottom).offset(CurrentDeviceSize(50));
    }];
    
    [self.wifiTranferBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.wifiBgView.mas_right).offset(-CurrentDeviceSize(20));
        make.centerY.equalTo(weakself.wifiBgView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(10), CurrentDeviceSize(20)));
    }];
    
    [self.wifiNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.top.bottom.equalTo(@0);
        make.right.equalTo(weakself.wifiTranferBtn.mas_left);
    }];
}

- (void)settingBtnClicked
{
    NSString *wifi = @"App-Prefs:root=WIFI";
    NSURL *url = [NSURL URLWithString:wifi];
    if ([[UIApplication sharedApplication]canOpenURL:url]) {
        if (SystemVersion >= 10) {
            [[UIApplication sharedApplication] openURL:url options:nil completionHandler:nil];
        }else
        {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}

- (void)wifiTranferBtnClicked
{
    [self.navigationController pushViewController:[NSClassFromString(@"MyDeviceConnectViewController") new] animated:YES];
}

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [UIImageView new];
    }
    return _imgView;
}

- (UILabel *)textLb
{
    if (!_textLb) {
        _textLb = [UILabel new];
        _textLb.font = [UIFont sf_systemFontOfSize:13];
        _textLb.text = @"请长按设备开关5秒使其进入AP模式";
    }
    return _textLb;
}

- (UIButton *)settingBtn
{
    if (!_settingBtn) {
        _settingBtn = [UIButton new];
        [_settingBtn addTarget:self action:@selector(settingBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_settingBtn setBackgroundImage:[UIImage imageNamed:@"btnBg"] forState:UIControlStateNormal];
        [_settingBtn.titleLabel setTextColor:[UIColor whiteColor]];
        [_settingBtn setTitle:@"前往设置" forState:UIControlStateNormal];
    }
    return _settingBtn;
}

- (UIView *)wifiBgView
{
    if (!_wifiBgView) {
        _wifiBgView = [UIView new];
        _wifiBgView.backgroundColor = [UIColor whiteColor];
    }
    return _wifiBgView;
}

- (UILabel *)wifiNameLb
{
    if (!_wifiNameLb) {
        _wifiNameLb = [UILabel new];
        _wifiNameLb.text = @"无线开关: xxxxxx";
        _wifiNameLb.font = [UIFont sf_systemFontOfSize:13];
        _wifiNameLb.textAlignment = NSTextAlignmentLeft;
    }
    return _wifiNameLb;
}

- (UIButton *)wifiTranferBtn
{
    if (!_wifiTranferBtn) {
        _wifiTranferBtn = [UIButton new];
        [_wifiTranferBtn setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
        [_wifiTranferBtn addTarget:self action:@selector(wifiTranferBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _wifiTranferBtn;
}
@end

