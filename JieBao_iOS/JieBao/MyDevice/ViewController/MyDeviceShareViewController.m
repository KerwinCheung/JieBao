//
//  MyDeviceRenameViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/19.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "MyDeviceShareViewController.h"

@interface MyDeviceShareViewController ()

@property (nonatomic, strong) UITextField *shareNameTv;

@property (nonatomic, strong) UIView *nameBgView;

@end

@implementation MyDeviceShareViewController


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
    
    ActionBlock rightAction = ^(UIButton *btn){
        [weakself shareDevice];
        LHLog(@"right");
    };
    [self.naviBar  configNavigationBarWithAttrs:@{
                                                  kCustomNaviBarLeftActionKey:leftAction,
                                                  kCustomNaviBarLeftImgKey:@"back",
                                                  kCustomNaviBarTitleKey:@"设备分享",
                                                  kCustomNaviBarRightActionKey:rightAction,
                                                  kCustomNaviBarRightImgKey:@"分享"
                                                  }];
}

- (void)initUI
{
    [self.bgView addSubview:self.nameBgView];
    [self.nameBgView addSubview:self.shareNameTv];
    
    LHWeakSelf(self)
    
    [self.nameBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(@(CurrentDeviceSize(40)));
        make.height.equalTo(@(CurrentDeviceSize(40)));
    }];
    
    [self.shareNameTv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.right.equalTo(weakself.view.mas_right).offset(-CurrentDeviceSize(20));
        make.top.bottom.equalTo(@0);
    }];
}

- (void)shareDevice
{
    if (self.shareNameTv.text.length == 0) {
        [HudHelper showInfoWithStatus:@"请输入分享人的账号"];
        return;
    }
    [SDKHelper shareInstance].shareCallBackBlock = ^(BOOL success) {
        if (success) {
            LHLog(@"分享成功");
            [HudHelper showSuccessWithStatus:@"分享成功"];
        }else
        {
            LHLog(@"分享失败");
            [HudHelper showSuccessWithStatus:@"分享失败"];
        }
    };
    [GizDeviceSharing sharingDevice:[UserHelper getCurrentUser].token deviceID:self.dev.did sharingWay:GizDeviceSharingByNormal guestUser:self.shareNameTv.text guestUserType:GizUserPhone];
    [self alertShowMessage:[NSString stringWithFormat:@"已向\"%@\"发送了一个设备分享邀请",self.shareNameTv.text] title:@"提示" confirmBtnText:@"确定" confirmCallback:nil];
    
}

- (UITextField *)shareNameTv
{
    if (!_shareNameTv) {
        _shareNameTv = [UITextField new];
        _shareNameTv.placeholder = @"请输入被分享人的账号";
        _shareNameTv.font = [UIFont sf_systemFontOfSize:13];
        _shareNameTv.backgroundColor = [UIColor whiteColor];
        _shareNameTv.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _shareNameTv;
}

- (UIView *)nameBgView
{
    if (!_nameBgView) {
        _nameBgView = [UIView new];
        [_nameBgView setBackgroundColor:UICOLORFROMRGB(0xFFFFFF)];
    }
    return _nameBgView;
}
@end


