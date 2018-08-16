//
//  MyDeviceRenameViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/19.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "MyDeviceRenameViewController.h"

@interface MyDeviceRenameViewController ()<GizWifiDeviceDelegate>

@property (nonatomic, strong) UITextField *deviceNameTv;

@property (nonatomic, strong) UIView *nameBgView;

@end

@implementation MyDeviceRenameViewController


- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UICOLORFROMRGB(0xededed);
    self.dev.delegate = self;
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
        [weakself save];
        LHLog(@"right");
    };
    [self.naviBar  configNavigationBarWithAttrs:@{
                                                  kCustomNaviBarLeftActionKey:leftAction,
                                                  kCustomNaviBarLeftImgKey:@"back",
                                                  kCustomNaviBarTitleKey:@"设备重命名",
                                                  kCustomNaviBarRightActionKey:rightAction,
                                                  kCustomNaviBarRightImgKey:@"baocun"
                                                  }];
    
    NSRange range = NSMakeRange(self.dev.macAddress.length - 6, 6);
    NSString *lastMacStr = [self.dev.macAddress substringWithRange:range];
    NSString *deaultStr = [NSString stringWithFormat:@"%@%@",[UtilHelper getDefaultNameStrPrefixWithProductKey:self.dev.productKey],lastMacStr];
    self.deviceNameTv.text = self.dev.alias.length == 0?deaultStr:self.dev.alias;

    
}

- (void)initUI
{
    [self.bgView addSubview:self.nameBgView];
    [self.nameBgView addSubview:self.deviceNameTv];
    
    LHWeakSelf(self)
    
    [self.nameBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(@(CurrentDeviceSize(40)));
        make.height.equalTo(@(CurrentDeviceSize(40)));
    }];
    
    [self.deviceNameTv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.right.equalTo(weakself.view.mas_right).offset(-CurrentDeviceSize(20));
        make.top.bottom.equalTo(@0);
    }];
}

- (void)save
{
    if (self.deviceNameTv.text.length == 0) {
        [HudHelper showInfoWithStatus:@"请输入名字"];
        return;
    }
    self.dev.delegate = self;
    [self.dev setCustomInfo:@"" alias:self.deviceNameTv.text];
}


- (void)device:(GizWifiDevice *)device didSetCustomInfo:(NSError *)result
{
    if (result.code == GIZ_SDK_SUCCESS) {
        [HudHelper showSuccessWithStatus:@"修改成功"];
        [self.navigationController popViewControllerAnimated:YES];
        LHLog(@"更改成功");
    }else
    {
        [HudHelper showErrorWithStatus:@"修改失败"];
    }
}

- (UITextField *)deviceNameTv
{
    if (!_deviceNameTv) {
        _deviceNameTv = [UITextField new];
        _deviceNameTv.placeholder = @"请输入设备名称";
        
        _deviceNameTv.font = [UIFont sf_systemFontOfSize:13];
        _deviceNameTv.backgroundColor = [UIColor whiteColor];
        _deviceNameTv.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _deviceNameTv;
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
