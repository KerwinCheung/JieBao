//
//  ZaoLangBengStartViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/6/19.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "ZaoLangBengStartViewController.h"

@interface ZaoLangBengStartViewController ()<GizWifiDeviceDelegate>

@property (nonatomic, strong) UIButton *turnBtn;

@end

@implementation ZaoLangBengStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.backgroundColor = UICOLORFROMRGB(0xf0f0f0);
    [self.bgView addSubview:self.turnBtn];
    self.turnBtn.selected = self.selected;
    LHWeakSelf(self);
    [self.turnBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view);
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(100), CurrentDeviceSize(100)));
        make.top.equalTo(@(CurrentDeviceSize(40)));
    }];
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
//        [weakself showMore];
    };
    [self.naviBar  configNavigationBarWithAttrs:@{
                                                  kCustomNaviBarLeftActionKey:leftAction,
                                                  kCustomNaviBarLeftImgKey:@"back",
                                                  kCustomNaviBarTitleKey:self.dev.alias.length==0?self.dev.productName:self.dev.alias,
                                                  kCustomNaviBarRightImgKey:@"more",
                                                  kCustomNaviBarRightActionKey:rightAction
                                                  
                                                  }];
}

- (void)turnBtnClicked:(UIButton *)btn
{
    btn.selected = !btn.selected;
    self.dev.delegate = self;
    [self.dev write:@{@"master":@(btn.selected)} withSN:1111];
}

- (void)device:(GizWifiDevice *)device didReceiveData:(NSError *)result data:(NSDictionary<NSString *,id> *)dataMap withSN:(NSNumber *)sn
{
    if (result.code == GIZ_SDK_SUCCESS) {
        if ([sn integerValue] == 1111) {
            [self alertShowMessage:@"设置成功" title:@"提示" confirmBtnText:@"确定" confirmCallback:nil];
        }
    }else
    {
        [self alertShowMessage:@"设置失败" title:@"提示" confirmBtnText:@"确定" confirmCallback:nil];
    }
}

- (UIButton *)turnBtn
{
    if (!_turnBtn) {
        _turnBtn = [UIButton new];
        [_turnBtn addTarget:self action:@selector(turnBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _turnBtn.backgroundColor = UICOLORFROMRGB(0xf0f0f0);
        [_turnBtn setImage:[UIImage imageNamed:@"open"] forState:UIControlStateSelected];
        [_turnBtn setImage:[UIImage imageNamed:@"shuibeng_close"] forState:UIControlStateNormal];
    }
    return _turnBtn;
}

@end
