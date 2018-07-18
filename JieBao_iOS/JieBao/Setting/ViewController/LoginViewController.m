//
//  LoginViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/12.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "LoginViewController.h"
#import "UIViewController+Custom.h"
#import "SettingViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *headImgView;

@property (nonatomic, strong) UIImageView *phoneImgView;

@property (nonatomic, strong) UIImageView *pswImgView;

@property (nonatomic, strong) UITextField *usrTextView;

@property (nonatomic, strong) UITextField *pswTextView;

@property (nonatomic, strong) UIButton *visableBtn;

@property (nonatomic, strong) UIButton *loginBtn;

@property (nonatomic, strong) UIButton *registerNewBtn;

@property (nonatomic, strong) UIButton *fogotPswBtn;

@property (nonatomic, strong) UIView *userSepLine;

@property (nonatomic, strong) UIView *pswSepLine;

@end

@implementation LoginViewController

- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
    [self.pswTextView addTarget:self action:@selector(conTextChange:) forControlEvents:UIControlEventEditingChanged];
    [self.usrTextView addTarget:self action:@selector(conTextChange:) forControlEvents:UIControlEventEditingChanged];
    if ([UserHelper getCurrentUser]) {
        [self loginBtnEnable];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.naviBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
    [self.naviBar setHidden:NO];
}

- (void)initUI
{
    [self.view addSubview:self.headImgView];
    [self.view addSubview:self.phoneImgView];
    [self.view addSubview:self.pswImgView];
    [self.view addSubview:self.usrTextView];
    [self.view addSubview:self.userSepLine];
    [self.view addSubview:self.pswTextView];
    [self.view addSubview:self.pswSepLine];
    [self.view addSubview:self.visableBtn];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.registerNewBtn];
    [self.view addSubview:self.fogotPswBtn];
    
    [self makeContraints];
}

- (void)makeContraints
{
    LHWeakSelf(self)
    [self.headImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(LL_NavigationBarHeight + CurrentDeviceSize(60)));
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(80), CurrentDeviceSize(80)));
    }];
    
    [self.phoneImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.top.equalTo(weakself.headImgView.mas_bottom).offset(CurrentDeviceSize(60));
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(20), CurrentDeviceSize(30)));
    }];
    
    [self.pswImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.phoneImgView.mas_left);
        make.top.equalTo(weakself.phoneImgView.mas_bottom).offset(CurrentDeviceSize(30));
        make.size.equalTo(weakself.phoneImgView);
    }];
    
    [self.usrTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.phoneImgView.mas_right).offset(CurrentDeviceSize(20));
        make.bottom.equalTo(weakself.phoneImgView.mas_bottom);
        make.height.mas_equalTo(CurrentDeviceSize(40));
        make.right.equalTo(weakself.userSepLine);
    }];
    
    [self.userSepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.phoneImgView.mas_right).offset(CurrentDeviceSize(10));
        make.bottom.equalTo(weakself.usrTextView.mas_bottom);
        make.right.equalTo(weakself.view.mas_right).offset(-CurrentDeviceSize(30));
        make.height.equalTo(@0.5);
    }];

    [self.visableBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.pswSepLine.mas_right);
        make.centerY.equalTo(weakself.pswImgView.mas_centerY).offset(-CurrentDeviceSize(4));
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(20), CurrentDeviceSize(20)));
    }];
    
    [self.pswTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.usrTextView.mas_left);
        make.bottom.equalTo(weakself.pswImgView.mas_bottom);
        make.right.equalTo(weakself.visableBtn.mas_left).offset(-CurrentDeviceSize(10));
        make.height.equalTo(@(CurrentDeviceSize(40)));
    }];
    
    [self.pswSepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.pswImgView.mas_right).offset(CurrentDeviceSize(10));
        make.bottom.equalTo(weakself.pswTextView.mas_bottom);
        make.right.equalTo(weakself.view.mas_right).offset(-CurrentDeviceSize(30));
        make.height.equalTo(@0.5);
    }];
    

    [self.loginBtn  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.phoneImgView);
        make.right.equalTo(weakself.userSepLine);
        make.top.equalTo(weakself.pswTextView.mas_bottom).offset(CurrentDeviceSize(35));
        make.height.equalTo(@(CurrentDeviceSize(35)));
    }];
    
    [self.registerNewBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.loginBtn.mas_left);
        make.top.equalTo(weakself.loginBtn.mas_bottom).offset(CurrentDeviceSize(15));
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(100), CurrentDeviceSize(20)));
    }];
    
    [self.fogotPswBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.loginBtn.mas_right);
        make.top.equalTo(weakself.loginBtn.mas_bottom).offset(CurrentDeviceSize(15));;
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(100), CurrentDeviceSize(20)));
    }];
}

#pragma mark - UI事件
- (void)loginBtnEnable
{
    self.loginBtn.userInteractionEnabled = YES;
    [self.loginBtn setBackgroundColor:[UIColor clearColor]];
    [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"btnBg"] forState:UIControlStateNormal];
}

- (void)visableBtnClicked:(UIButton *)btn
{
    btn.selected = !btn.selected;
    [self.pswTextView setSecureTextEntry:!btn.selected];
}

- (void)loginBtnCilcked
{
    LHWeakSelf(self)
    if (self.usrTextView.text.length != 11) {
        [HudHelper showErrorWithStatus:@"请输入正确手机号码"];
        return;
    }
    
    if (self.pswTextView.text.length < 6 || self.pswTextView.text.length > 16) {
        [HudHelper showErrorWithStatus:@"请输入6-16位密码"];

        return;
    }
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            [HudHelper showStatus:@"请检查网络设置"];
        }
    }];
    
    [SVProgressHUD show];
    [SDKHelper shareInstance].loginBlock = ^(BOOL success) {
        [SVProgressHUD dismiss];
        if (success) {
            UserModel *model = [UserHelper getCurrentUser];
            model.userName = weakself.usrTextView.text;
            model.psw = weakself.pswTextView.text;
            [UserHelper setCurrentUser:model];
            
            [[[UIApplication sharedApplication] delegate] performSelector:@selector(changeRootViewController) withObject:nil];
        }else
        {
            //登录失败
        }
    };
    [[GizWifiSDK sharedInstance] userLogin:self.usrTextView.text password:self.pswTextView.text];
}

- (void)registerNewBtnClicked
{
    [self.navigationController pushViewController:[NSClassFromString(@"RegisterViewController") new] animated:YES];
}

- (void)fogotPswBtnClicked
{
    [self.navigationController pushViewController:[NSClassFromString(@"FogotPswViewController") new] animated:YES];
}

- (void)conTextChange:(UITextField *)textField
{
    if (self.usrTextView.text.length != 0 && self.pswTextView.text.length != 0) {
        [self.loginBtn setBackgroundColor:[UIColor clearColor]];
        [self loginBtnEnable];
    }else
    {
        self.loginBtn.userInteractionEnabled = NO;
        [self.loginBtn setBackgroundImage:nil forState:UIControlStateNormal];
        [self.loginBtn setBackgroundColor:[UIColor grayColor]];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:self.usrTextView]) {
        if (self.usrTextView.text.length == 11) {
            return NO;
        }
    }else if([textField isEqual:self.pswTextView])
    {
        if (self.pswTextView.text.length == 16) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.loginBtn.userInteractionEnabled = NO;
    [self.loginBtn setBackgroundImage:nil forState:UIControlStateNormal];
    [self.loginBtn setBackgroundColor:[UIColor grayColor]];
    return YES;
}


#pragma mark - lazy init
- (UIImageView *)headImgView
{
    if (!_headImgView) {
#warning 暂时屏蔽，真机第二次就崩溃
        _headImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"head"]];
//        _headImgView = [[UIImageView alloc] init];
    }
    return _headImgView;
}

- (UIImageView *)phoneImgView
{
    if (!_phoneImgView) {
        _phoneImgView = [UIImageView new];
        _phoneImgView.image = [UIImage imageNamed:@"phone"];
    }
    return _phoneImgView;
}

- (UIImageView *)pswImgView
{
    if (!_pswImgView) {
        _pswImgView = [UIImageView new];
        _pswImgView.image = [UIImage imageNamed:@"mima"];
    }
    return _pswImgView;
}

- (UITextField *)usrTextView
{
    if (!_usrTextView) {
        _usrTextView = [UITextField new];
        _usrTextView.placeholder = @"请输入您的手机号";
        _usrTextView.font = [UIFont sf_systemFontOfSize:13];
        _usrTextView.text = [UserHelper getCurrentUser].userName;
        _usrTextView.clearButtonMode = UITextFieldViewModeWhileEditing;
        _usrTextView.keyboardType = UIKeyboardTypeNumberPad;
        _usrTextView.delegate = self;
    }
    return _usrTextView;
}

- (UITextField *)pswTextView
{
    if (!_pswTextView) {
        _pswTextView = [UITextField new];
        _pswTextView.placeholder = @"请输入6-16位的密码";
        _pswTextView.font = self.usrTextView.font;
        _pswTextView.text = [UserHelper getCurrentUser].psw;
        _pswTextView.delegate = self;
        _pswTextView.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_pswTextView setSecureTextEntry:YES];
    }
    return _pswTextView;
}

- (UIButton *)visableBtn
{
    if (!_visableBtn) {
        _visableBtn = [UIButton new];
        [_visableBtn addTarget:self action:@selector(visableBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_visableBtn setImage:[UIImage imageNamed:@"bukejian"] forState:UIControlStateNormal];
        [_visableBtn setImage:[UIImage imageNamed:@"kejian"] forState:UIControlStateSelected];
    }
    return _visableBtn;
}

- (UIButton *)loginBtn
{
    if (!_loginBtn) {
        _loginBtn = [UIButton new];
        [_loginBtn addTarget:self action:@selector(loginBtnCilcked) forControlEvents:UIControlEventTouchUpInside];
        [_loginBtn.titleLabel setFont:[UIFont sf_systemFontOfSize:16]];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginBtn.layer.masksToBounds = YES;
        _loginBtn.layer.cornerRadius = 5;
        [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
        _loginBtn.userInteractionEnabled = NO;
        [_loginBtn setBackgroundColor:[UIColor grayColor]];
    }
    return _loginBtn;
}

- (UIButton *)registerNewBtn
{
    if (!_registerNewBtn) {
        _registerNewBtn = [UIButton new];
        [_registerNewBtn addTarget:self action:@selector(registerNewBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        _registerNewBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_registerNewBtn.titleLabel setFont:[UIFont sf_systemFontOfSize:12]];
        [_registerNewBtn setTitleColor:UICOLORFROMRGB(0X8e8e8e) forState:UIControlStateNormal];
        [_registerNewBtn setTitle:@"注册新用户" forState:UIControlStateNormal];
    }
    return _registerNewBtn;
}

- (UIButton *)fogotPswBtn
{
    if (!_fogotPswBtn) {
        _fogotPswBtn = [UIButton new];
        [_fogotPswBtn addTarget:self action:@selector(fogotPswBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        _fogotPswBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_fogotPswBtn.titleLabel setFont:self.registerNewBtn.titleLabel.font];
        [_fogotPswBtn setTitleColor:UICOLORFROMRGB(0X8e8e8e) forState:UIControlStateNormal];
        [_fogotPswBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    }
    return _fogotPswBtn;
}

- (UIView *)userSepLine
{
    if (!_userSepLine) {
        _userSepLine = [UIView new];
        _userSepLine.backgroundColor = [UIColor lightGrayColor];
    }
    return _userSepLine;
}

- (UIView *)pswSepLine
{
    if (!_pswSepLine) {
        _pswSepLine = [UIView new];
        _pswSepLine.backgroundColor = [UIColor lightGrayColor];
    }
    return _pswSepLine;
}
@end
