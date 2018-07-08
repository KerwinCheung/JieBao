//
//  RegisterSuccessViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/25.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "RegisterSuccessViewController.h"
#import "SettingViewController.h"

@interface RegisterSuccessViewController ()

@property (nonatomic, strong) UIImageView *successImgView;

@property (nonatomic, strong) UILabel *tipLb;

@property (nonatomic, strong) UIButton *startBtn;

@end

@implementation RegisterSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UICOLORFROMRGB(0xededed);
    [self.bgView addSubview:self.successImgView];
    [self.bgView addSubview:self.tipLb];
    [self.bgView addSubview:self.startBtn];
    
    LHWeakSelf(self)
    [self.successImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view);
        make.top.equalTo(@(CurrentDeviceSize(LL_ScreenHeight/6)));
        make.size.mas_equalTo(CGSizeMake(LL_ScreenHeight/6, LL_ScreenHeight/6));
    }];
    
    [self.tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view);
        make.top.equalTo(weakself.successImgView.mas_bottom).offset(CurrentDeviceSize(20));
        make.width.lessThanOrEqualTo(@200);
    }];
    
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view);
        make.top.equalTo(weakself.tipLb.mas_bottom).offset(LL_ScreenHeight/6);
        make.height.equalTo(@(CurrentDeviceSize(35)));
        make.width.equalTo(@(LL_ScreenWidth - CurrentDeviceSize(80)));
    }];
}

- (void)startBtnClicked
{
    LHWeakSelf(self)
    UserModel *model = [UserHelper getCurrentUser];
    [[GizWifiSDK sharedInstance] userLogin:model.userName password:model.psw];
    [SDKHelper shareInstance].loginBlock = ^(BOOL success) {
        for (UIViewController *vc in weakself.navigationController.viewControllers) {
            if ([vc isKindOfClass:[SettingViewController class]]) {
                [weakself.navigationController popToViewController:vc animated:YES];
                ((SettingViewController *)vc).currentUser = model;
                break;
            }
        }
    };
}

- (UIImageView *)successImgView
{
    if (!_successImgView) {
        _successImgView = [UIImageView alloc];
        _successImgView.image = [UIImage imageNamed:@"queren"];
    }
    return _successImgView;
}

- (UILabel *)tipLb
{
    if (!_tipLb) {
        _tipLb = [UILabel new];
        _tipLb.font = [UIFont sf_systemFontOfSize:15];
        _tipLb.text = @"恭喜您账号已经注册成功!";
    }
    return _tipLb;
}

- (UIButton *)startBtn
{
    if (!_startBtn) {
        _startBtn = [UIButton new];
        [_startBtn addTarget:self action:@selector(startBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_startBtn setBackgroundImage:[UIImage imageNamed:@"star"] forState:UIControlStateNormal];
        [_startBtn.titleLabel setFont:[UIFont sf_systemFontOfSize:13]];
        _startBtn.layer.masksToBounds = YES;
        _startBtn.layer.cornerRadius = CurrentDeviceSize(5);
    }
    return _startBtn;
}
@end
