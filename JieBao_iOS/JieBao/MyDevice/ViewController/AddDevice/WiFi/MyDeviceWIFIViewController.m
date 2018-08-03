//
//  MyDeviceWIFIViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/18.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "MyDeviceWIFIViewController.h"
#import "MyDevicecContractViewController.h"

@interface MyDeviceWIFIViewController ()

@property (nonatomic, strong) UIImageView *wifiImgView;

@property (nonatomic, strong) UIView *wifiNameBgView;

@property (nonatomic, strong) UIImageView *wifiLogoImgView;

@property (nonatomic, strong) UILabel *wifiNameLb;

@property (nonatomic, strong) UIView *wifiPswBgView;

@property (nonatomic, strong) UIImageView *wifiPswImgView;

@property (nonatomic, strong) UITextField *wifiPswText;

@property (nonatomic, strong) UIButton *visableBtn;

@property (nonatomic, strong) UILabel *tipLb;

@property (nonatomic, strong) UIButton *nextBtn;

@end

@implementation MyDeviceWIFIViewController

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
                                                  kCustomNaviBarTitleKey:@"添加设备",
                                                  }];
}

- (void)initUI
{
    [self.view addSubview:self.wifiImgView];
    [self.view addSubview:self.wifiNameBgView];
    [self.wifiNameBgView addSubview:self.wifiLogoImgView];
    [self.wifiNameBgView addSubview:self.wifiNameLb];
    [self.view addSubview:self.wifiPswBgView];
    [self.wifiPswBgView addSubview:self.wifiPswImgView];
    [self.wifiPswBgView addSubview:self.wifiPswText];
    [self.wifiPswBgView addSubview:self.visableBtn];
    [self.view addSubview:self.tipLb];
    [self.view addSubview:self.nextBtn];
    
    [self makeContraints];
}

- (void)makeContraints
{
    LHWeakSelf(self)
    [self.wifiImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.top.equalTo(@(CurrentDeviceSize(80 + LL_StatusBarAndNavigationBarHeight)));
        make.size.mas_equalTo(@(CGSizeMake(CurrentDeviceSize(168), CurrentDeviceSize(160))));
    }];
    
    [self.wifiNameBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.right.equalTo(weakself.view.mas_right).offset(-CurrentDeviceSize(20));
        make.top.equalTo(weakself.wifiImgView.mas_bottom).offset(CurrentDeviceSize(20));
        make.height.equalTo(@(CurrentDeviceSize(40)));
    }];
    
    [self.wifiLogoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(5)));
        make.centerY.equalTo(weakself.wifiNameBgView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(21, 21));
    }];
    
    
    [self.wifiNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.wifiLogoImgView.mas_right).offset(CurrentDeviceSize(10));
        make.top.right.bottom.equalTo(@0);
    }];
    
    [self.wifiPswBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakself.wifiNameBgView);
        make.top.equalTo(weakself.wifiNameBgView.mas_bottom).offset(CurrentDeviceSize(40));
        make.height.equalTo(@(CurrentDeviceSize(40)));
    }];
    
    [self.wifiPswImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.wifiLogoImgView.mas_left);
        make.centerY.equalTo(weakself.wifiPswBgView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(22,27));
    }];
    
    [self.wifiPswText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.wifiLogoImgView.mas_right).offset(CurrentDeviceSize(10));
        make.top.bottom.equalTo(@0);
        make.right.equalTo(weakself.visableBtn.mas_left);
    }];
    
    [self.visableBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.wifiPswBgView.mas_right).offset(-CurrentDeviceSize(20));
        make.centerY.equalTo(weakself.wifiPswBgView.mas_centerY);
        make.size.equalTo(weakself.wifiPswImgView);
    }];
    
    [self.tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.top.equalTo(weakself.wifiPswBgView.mas_bottom).offset(CurrentDeviceSize(40));
        make.height.equalTo(@36);
        make.width.lessThanOrEqualTo(@300);
    }];
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.bottom.equalTo(weakself.view.mas_bottom).offset(-CurrentDeviceSize(100));
        make.width.equalTo(@(LL_ScreenWidth - 40));
        make.height.equalTo(@(CurrentDeviceSize(35)));
    }];
}

#pragma mark - lazy init
- (void)nextBtnClicked
{
    if (self.wifiPswText.text.length == 0) {
        [HudHelper showErrorWithStatus:@"请输入wifi密码"];
        return;
    }
    MyDevicecContractViewController *vc = [MyDevicecContractViewController new];
    vc.ssid = self.wifiNameLb.text;
    vc.key = self.wifiPswText.text;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)visableBtnClicked:(UIButton *)btn
{
    [self.wifiPswText setSecureTextEntry:!btn.selected];
    btn.selected = !btn.selected;
}

#pragma mark - lazy init
- (UIImageView *)wifiImgView
{
    if (!_wifiImgView) {
        _wifiImgView = [UIImageView new];
        _wifiImgView.image = [UIImage imageNamed:@"wifi"];
    }
    return _wifiImgView;
}

- (UIImageView *)wifiLogoImgView
{
    if (!_wifiLogoImgView) {
        _wifiLogoImgView = [UIImageView new];
        _wifiLogoImgView.image = [UIImage imageNamed:@"shebeimingc"];
    }
    return _wifiLogoImgView;
}

- (UIImageView *)wifiPswImgView
{
    if (!_wifiPswImgView) {
        _wifiPswImgView = [UIImageView new];
        _wifiPswImgView.image = [UIImage imageNamed:@"mima"];
    }
    return _wifiPswImgView;
}


- (UIView *)wifiNameBgView
{
    if (!_wifiNameBgView) {
        _wifiNameBgView = [UIView new];
        _wifiNameBgView.backgroundColor = [UIColor whiteColor];
    }
    return _wifiNameBgView;
}

- (UIView *)wifiPswBgView
{
    if (!_wifiPswBgView) {
        _wifiPswBgView = [UIView new];
        _wifiPswBgView.backgroundColor = [UIColor whiteColor];
    }
    return _wifiPswBgView;
}

- (UILabel *)wifiNameLb
{
    if (!_wifiNameLb) {
        _wifiNameLb = [UILabel new];
        _wifiNameLb.font = [UIFont sf_systemFontOfSize:13];
        _wifiNameLb.text = [UtilHelper getSSID];
    }
    return _wifiNameLb;
}

- (UITextField *)wifiPswText
{
    if (!_wifiPswText) {
        _wifiPswText = [UITextField new];
        _wifiPswText.placeholder = @"请输入wifi密码";
        _wifiPswText.font = [UIFont sf_systemFontOfSize:13];
        if ([UtilHelper getWifi][kUserWIFINameKey]) {
            _wifiPswText.text = [UtilHelper getWifi][kUserWIFINameKey];
        }
    }
    return _wifiPswText;
}

- (UIButton *)visableBtn
{
    if (!_visableBtn) {
        _visableBtn = [UIButton new];
        [_visableBtn addTarget:self action:@selector(visableBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_visableBtn setImage:[UIImage imageNamed:@"kejian"] forState:UIControlStateNormal];
        [_visableBtn setImage:[UIImage imageNamed:@"bukejian"] forState:UIControlStateSelected];
    }
    return _visableBtn;
}

- (UILabel *)tipLb
{
    if (!_tipLb) {
        _tipLb = [UILabel new];
        _tipLb.font = [UIFont sf_systemFontOfSize:13];
        _tipLb.numberOfLines = 0;
        _tipLb.text = @"提示:暂不支持5G频段WiFi,请选择2.4G频段";
    }
    return _tipLb;
}

- (UIButton *)nextBtn
{
    if (!_nextBtn) {
        _nextBtn = [UIButton new];
        [_nextBtn addTarget:self action:@selector(nextBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_nextBtn setBackgroundImage:[UIImage imageNamed:@"btnBg"] forState:UIControlStateNormal];
        [_nextBtn.titleLabel setTextColor:[UIColor whiteColor]];
        _nextBtn.layer.masksToBounds = YES;
        _nextBtn.layer.cornerRadius = CurrentDeviceSize(5);
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    }
    return _nextBtn;
}

@end
