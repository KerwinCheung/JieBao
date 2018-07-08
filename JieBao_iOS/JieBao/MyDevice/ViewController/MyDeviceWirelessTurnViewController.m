//
//  TurnViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/17.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "MyDeviceWirelessTurnViewController.h"
#import "UIViewController+Custom.h"
#import "MyDeviceRenameViewController.h"
#import "MyDeviceShareViewController.h"
#import "WirelessTurnSettingViewController.h"

@interface MyDeviceWirelessTurnViewController ()<GizWifiDeviceDelegate>

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

@implementation MyDeviceWirelessTurnViewController

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
    self.dev.delegate = self;
    [self.dev setSubscribe:self.dev.productKey subscribed:YES];
    [self.dev getDeviceStatus:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
    LHWeakSelf(self)
    ActionBlock leftAction = ^(UIButton *btn){
        [weakself.navigationController popViewControllerAnimated:YES];
        LHLog(@"left");
    };
    ActionBlock rightAction = ^(UIButton *btn){
        [weakself showMore];
    };
    [self.naviBar  configNavigationBarWithAttrs:@{
                                                  kCustomNaviBarLeftActionKey:leftAction,
                                                  kCustomNaviBarLeftImgKey:@"back",
                                                  kCustomNaviBarTitleKey:@"无线开关",
                                                  kCustomNaviBarRightImgKey:@"more",
                                                  kCustomNaviBarRightActionKey:rightAction
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

- (void)showMore
{
    LHWeakSelf(self)
    ConfirmCallback renameCallBack = ^(){
        [weakself rename];
    };
    
    ConfirmCallback shareDeviceCallBack = ^(){
        [weakself shareDevice];
    };
    
    ConfirmCallback deleteDeviceCallBack = ^(){
        [weakself deleteDevice];
    };
    
    [self actionSheetShowMessage:@[@"重命名",@"设备分享",@"删除设备"] confirmCallbacks:@[renameCallBack,shareDeviceCallBack,deleteDeviceCallBack] cancelCallback:nil];
}

- (void)rename
{
    MyDeviceRenameViewController *vc = [MyDeviceRenameViewController new];
    vc.dev = self.dev;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)shareDevice
{
    MyDeviceShareViewController *vc = [MyDeviceShareViewController new];
    vc.dev = self.dev;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)deleteDevice
{
    [[GizWifiSDK sharedInstance] unbindDevice:[UserHelper getCurrentUser].uid token:[UserHelper getCurrentUser].token did:self.dev.did];
}

- (void)turnBtnClicked
{
    LHLog(@"open");
    [self.navigationController pushViewController:[NSClassFromString(@"MyDeviceWirelessSettingViewController") new] animated:YES];
}

-  (void)appConBtnClicked
{
    LHLog(@"appConBtnClicked");
    [self.navigationController pushViewController:[NSClassFromString(@"MyDeviceAPControlViewController") new] animated:YES];
}

- (void)ch1BtnClicked
{
    LHLog(@"ch1BtnClicked");
    WirelessTurnSettingViewController *vc = [WirelessTurnSettingViewController new];
    vc.dev = self.dev;
    [self.navigationController pushViewController:vc animated:YES];
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

- (void)device:(GizWifiDevice *)device didSetSubscribe:(NSError *)result isSubscribed:(BOOL)isSubscribed
{
    if(result.code == GIZ_SDK_SUCCESS) {
        // 订阅或取消订阅成功
        if (isSubscribed) {
            LHLog(@"订阅成功");
        }else
        {
            LHLog(@"订阅失败");
        }
    }
}

- (void)device:(GizWifiDevice *)device didReceiveData:(NSError *)result data:(NSDictionary<NSString *,id> *)dataMap withSN:(NSNumber *)sn
{
    if(result.code == GIZ_SDK_SUCCESS) {
        if (sn == 0) {
            LHLog(@"属性%@",dataMap);
            NSDictionary *data = dataMap[@"data"];
            BOOL turnStatus = [data[@"switch"] boolValue];
            NSDictionary *ch1Data = data[@"channe1"];
            BOOL ch1Status = [ch1Data[@"channe1"] boolValue];
            BOOL ch1Mode = [ch1Data[@"TimerON"] boolValue];
            
            NSDictionary *ch2Data = data[@"channe2"];
            BOOL ch2Status = [ch2Data[@"channe2"] boolValue];
            BOOL ch2Mode = [ch2Data[@"TimerON"] boolValue];
            
            NSDictionary *ch3Data = data[@"channe3"];
            BOOL ch3Status = [ch3Data[@"channe3"] boolValue];
            BOOL ch3Mode = [ch3Data[@"TimerON"] boolValue];
            
            NSDictionary *ch4Data = data[@"channe4"];
            BOOL ch4Status = [ch4Data[@"channe4"] boolValue];
            BOOL ch4Mode = [ch4Data[@"TimerON"] boolValue];
        }
    }
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
        _btnsView.userInteractionEnabled = YES;
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


