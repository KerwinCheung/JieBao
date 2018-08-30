//
//  RegisterViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/12.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "RegisterViewController.h"
#import "UserModel.h"
#include "UIViewController+Custom.h"


@interface RegisterViewController ()<UITextFieldDelegate,GizWifiSDKDelegate>

@property (nonatomic, strong) UIImageView *phoneImgView;

@property (nonatomic, strong) UIImageView *validateImgView;

@property (nonatomic, strong) UIImageView *pswImgView;

@property (nonatomic, strong) UITextField *usrTextView;

@property (nonatomic, strong) UITextField *validateTextView;

@property (nonatomic, strong) UITextField *pswTextView;

@property (nonatomic, strong) UIButton *getValidateBtn;

@property (nonatomic, strong) UITextField *rePswTextView;

@property (nonatomic, strong) UIButton *pswVisableBtn;

@property (nonatomic, strong) UIButton *rePswVisableBtn;

@property (nonatomic, strong) UIButton *registerBtn;

@property (nonatomic, strong) UIView *userSepLine;

@property (nonatomic, strong) UIView *validateSepLine;

@property (nonatomic, strong) UIView *pswSepLine;

@property (nonatomic, strong) UIView *repswSepLine;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger secs;

@end

@implementation RegisterViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.secs = kTimeSecs;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initUI];
    
    self.getValidateBtn.enabled = NO;
    
    @weakify(self);
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note){
        @strongify(self);
        if ([note.object isEqual:self.usrTextView])
        {
            if ([UtilHelper isValidateMobile:self.usrTextView.text]) {
                self.getValidateBtn.enabled = YES;
                [self.getValidateBtn.titleLabel setTextColor:[UIColor whiteColor]];
            }else{
                self.getValidateBtn.enabled = NO;
            }
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    LHWeakSelf(self)
    ActionBlock leftAction = ^(UIButton *btn){
        [weakself.navigationController popViewControllerAnimated:YES];
    };
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(passConTextChange) name:UITextFieldTextDidChangeNotification object:nil];

    [self.naviBar  configNavigationBarWithAttrs:@{
                                                  kCustomNaviBarLeftActionKey:leftAction,
                                                  kCustomNaviBarLeftImgKey:@"back",
                                                  kCustomNaviBarTitleKey:@"注册"
                                                  }];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)initUI
{
    [self.bgView addSubview:self.phoneImgView];
    [self.bgView  addSubview:self.validateImgView];
    [self.bgView  addSubview:self.pswImgView];
    [self.bgView  addSubview:self.usrTextView];
    [self.bgView  addSubview:self.validateTextView];
    [self.bgView  addSubview:self.pswTextView];
    [self.bgView  addSubview:self.rePswTextView];
    [self.bgView  addSubview:self.getValidateBtn];
    [self.bgView  addSubview:self.pswVisableBtn];
    [self.bgView  addSubview:self.rePswVisableBtn];
    [self.bgView  addSubview:self.registerBtn];
    [self.bgView addSubview:self.userSepLine];
    [self.bgView addSubview:self.validateSepLine];
    [self.bgView addSubview:self.pswSepLine];
    [self.bgView addSubview:self.repswSepLine];
    
    [self makeContraints];
}

- (void)makeContraints
{
    LHWeakSelf(self)
    [self.phoneImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(20), CurrentDeviceSize(30)));
        make.top.equalTo(@(CurrentDeviceSize(60)));
    }];
    
    [self.validateImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.phoneImgView.mas_left);
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(22), CurrentDeviceSize(27)));

        make.top.equalTo(weakself.phoneImgView.mas_bottom).offset(CurrentDeviceSize(30));
    }];
    
    [self.pswImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.phoneImgView.mas_left);
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(22), CurrentDeviceSize(27)));

        make.top.equalTo(weakself.validateImgView.mas_bottom).offset(CurrentDeviceSize(30));
    }];
    
    [self.usrTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.phoneImgView.mas_right).offset(CurrentDeviceSize(20));
        make.centerY.equalTo(weakself.phoneImgView.mas_centerY);
        make.height.equalTo(weakself.phoneImgView.mas_height);
        make.right.equalTo(weakself.userSepLine.mas_right);
    }];
    
    [self.validateTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.validateImgView.mas_right).offset(CurrentDeviceSize(20));
        make.centerY.equalTo(weakself.validateImgView.mas_centerY);
        make.height.equalTo(weakself.validateImgView.mas_height);
        make.right.equalTo(weakself.validateSepLine.mas_right);
    }];
    
    [self.pswTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.usrTextView.mas_left);
        make.centerY.equalTo(weakself.pswImgView.mas_centerY);
        make.height.equalTo(weakself.pswImgView.mas_height);
        make.right.equalTo(weakself.pswVisableBtn.mas_left).offset(-CurrentDeviceSize(10));
    }];
    
    [self.rePswTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.usrTextView.mas_left);
        make.top.equalTo(weakself.pswTextView.mas_bottom).offset(CurrentDeviceSize(20));
        make.height.equalTo(weakself.usrTextView.mas_height);
        make.right.equalTo(weakself.rePswVisableBtn.mas_left).offset(-CurrentDeviceSize(10));
    }];
    
    [self.getValidateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.userSepLine.mas_right);
        make.centerY.equalTo(weakself.validateTextView.mas_centerY);
        make.height.equalTo(@(CurrentDeviceSize(30)));
        make.width.equalTo(@(CurrentDeviceSize(100)));
    }];
    
    [self.pswVisableBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.pswSepLine.mas_right);
        make.centerY.equalTo(weakself.pswImgView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(30), CurrentDeviceSize(30)));
    }];
    
    [self.rePswVisableBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.repswSepLine.mas_right);;
        make.centerY.equalTo(weakself.rePswTextView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(30), CurrentDeviceSize(30)));
    }];
    
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.phoneImgView);
        make.right.equalTo(weakself.userSepLine);
        make.top.equalTo(weakself.rePswTextView.mas_bottom).offset(CurrentDeviceSize(30));
        make.height.equalTo(@(CurrentDeviceSize(35)));
    }];
    
    
    [self.userSepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.phoneImgView.mas_right).offset(CurrentDeviceSize(10));
        make.bottom.equalTo(weakself.usrTextView.mas_bottom);
        make.right.equalTo(weakself.view.mas_right).offset(-CurrentDeviceSize(30));
        make.height.equalTo(@0.5);
    }];
    
    [self.validateSepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.validateImgView.mas_right).offset(CurrentDeviceSize(10));
        make.bottom.equalTo(weakself.validateTextView.mas_bottom);
        make.right.equalTo(weakself.getValidateBtn.mas_left).offset(-CurrentDeviceSize(10));
        make.height.equalTo(@0.5);
    }];
    
    [self.pswSepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.pswImgView.mas_right).offset(CurrentDeviceSize(10));
        make.bottom.equalTo(weakself.pswTextView.mas_bottom);
        make.right.equalTo(weakself.view.mas_right).offset(-CurrentDeviceSize(30));
        make.height.equalTo(@0.5);
    }];
    
    [self.repswSepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.pswImgView.mas_right).offset(CurrentDeviceSize(10));
        make.bottom.equalTo(weakself.rePswTextView.mas_bottom);
        make.right.equalTo(weakself.view.mas_right).offset(-CurrentDeviceSize(30));
        make.height.equalTo(@0.5);
    }];
}


- (void)getValidateBtnClicked
{
    if (self.usrTextView.text.length != 11 || ![UtilHelper isValidateMobile:self.usrTextView.text]) {
        [HudHelper showErrorWithStatus:@"请输入正确的手机号码"];
        return;
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeCount) userInfo:nil repeats:YES];
    [[GizWifiSDK sharedInstance] requestSendPhoneSMSCode:kAppSecrect phone:self.usrTextView.text];
    [GizWifiSDK sharedInstance].delegate = self;

}

- (void)timeCount
{
    self.getValidateBtn.enabled = NO;
    [self.getValidateBtn setTitle:[NSString stringWithFormat:@"%ld秒后重发",self.secs--] forState:UIControlStateNormal];
    if (self.secs == 0) {
        self.secs = kTimeSecs;
        [self.timer invalidate];
        self.timer = nil;
        self.getValidateBtn.enabled = YES;
       [self.getValidateBtn.titleLabel setTextColor:[UIColor whiteColor]];
       [self.getValidateBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
}

- (void)pswVisableBtnClicked:(UIButton *)btn
{
    btn.selected = !btn.selected;

    [self.pswTextView setSecureTextEntry:!btn.selected];
    NSString *tempStr = self.pswTextView.text;
    self.pswTextView.text = nil;
    self.pswTextView.text = tempStr;
}

- (void)rePswVisableBtnClicked:(UIButton *)btn
{
    btn.selected = !btn.selected;
    [self.rePswTextView setSecureTextEntry:!btn.selected];
    NSString *tempStr = self.rePswTextView.text;
    self.rePswTextView.text = nil;
    self.rePswTextView.text = tempStr;
}

- (void)registerBtnCilcked
{
    if (self.usrTextView.text.length != 11 || ![UtilHelper isValidateMobile:self.usrTextView.text]) {
        [HudHelper showErrorWithStatus:@"请输入正确手机号码"];
        return;
    }
    
    if (self.validateTextView.text.length == 0) {
        [HudHelper showErrorWithStatus:@"请输入验证码"];
        return;
    }
    if (self.pswTextView.text.length < 6 || self.pswTextView.text.length > 16) {
        [HudHelper showErrorWithStatus:@"请输入6~16位字符密码"];
        return;
    }
    
    if (![self.pswTextView.text isEqualToString:self.rePswTextView.text]) {
        [HudHelper showErrorWithStatus:@"确认密码一致"];
        return;
    }
    
    [HudHelper show];
    [self checkworking];
    
}

-(void)checkworking

{
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    /*
     AFNetworkReachabilityStatusUnknown          = -1, // 代表不知道什么网络
     AFNetworkReachabilityStatusNotReachable     = 0,  // 代表没有网络
     AFNetworkReachabilityStatusReachableViaWWAN = 1,    // 代表蜂窝数据(你自己的网络)
     AFNetworkReachabilityStatusReachableViaWiFi = 2, // 代表 wifi
     */
    [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        if (status == 0) {
            [HudHelper dismiss];
            UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"提示" message:@"没有网络" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定"style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            [controller addAction:action];
            [self presentViewController:controller animated:YES completion:nil];
        }else{
            
            [[GizWifiSDK sharedInstance] registerUser:self.usrTextView.text password:self.pswTextView.text verifyCode:self.validateTextView.text accountType:GizUserPhone];
            LHWeakSelf(self)
            [SDKHelper shareInstance].registerBlock = ^(BOOL success) {
                [HudHelper dismiss];
                if (success) {
                    [weakself.navigationController pushViewController:[NSClassFromString(@"RegisterSuccessViewController") new] animated:YES];
                    
                    UserModel *model = [UserHelper getCurrentUser];
                    model.userName = self.usrTextView.text;
                    model.psw = self.pswTextView.text;
                    [UserHelper setCurrentUser:model];
                }else{
                    LHLog(@"注册失败");
                }
            };
        }
    }];
    
    [manger startMonitoring];
}

- (void)passConTextChange
{
    if (self.usrTextView.text.length != 0 && self.validateTextView.text.length != 0&& self.pswTextView.text.length != 0 &&self.rePswTextView.text.length != 0) {
        self.registerBtn.enabled = YES;
        [self.registerBtn setBackgroundColor:[UIColor clearColor]];
        [self.registerBtn setBackgroundImage:[UIImage imageNamed:@"btnBg"] forState:UIControlStateNormal];
    }else
    {
        self.registerBtn.enabled = NO;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:self.usrTextView]) {
        if (self.usrTextView.text.length == 11 && ![string isEqualToString:@""]) {
            return NO;
        }
    }else if([textField isEqual:self.validateTextView])
    {
        if (self.validateTextView.text.length == 6) {
            return NO;
        }
    }else if([textField isEqual:self.pswTextView])
    {
        if (self.pswTextView.text.length == 16) {
            return NO;
        }
    }else if([textField isEqual:self.rePswTextView])
    {
        if (self.rePswTextView.text.length == 16) {
            return NO;
        }
    }
    return YES;
}



#pragma mark GzWifiDelegate
/**
 请求手机短信验证码的回调接口
 @param wifiSDK 回调的 GizWifiSDK 单例
 @param result 详细见 GizWifiErrorCode 枚举定义。result.code 为 GIZ_SDK_SUCCESS 表示成功，其他为失败。失败时，其他回调参数为 nil
 @param token 请求短信验证码时得到的 token
 @see 触发函数：[GizWifiSDK requestSendPhoneSMSCode:phone:]、[GizWifiSDK requestSendPhoneSMSCode:captchaId:captchaCode:phone:]
 @see GizWifiErrorCode
 */
- (void)wifiSDK:(GizWifiSDK * _Nonnull)wifiSDK didRequestSendPhoneSMSCode:(NSError * _Nonnull)result token:(NSString * _Nullable)token{
    if (result.code != GIZ_SDK_SUCCESS) {
        [HudHelper showErrorWithStatus:@"获取验证码失败"];
        self.secs = kTimeSecs;
        [self.timer invalidate];
        self.timer = nil;
        self.getValidateBtn.enabled = YES;
        [self.getValidateBtn.titleLabel setTextColor:[UIColor whiteColor]];
        [self.getValidateBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    }
    
}

#pragma mark - touchEven
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - lazy init
- (UIImageView *)phoneImgView
{
    if (!_phoneImgView) {
        _phoneImgView = [UIImageView new];
        _phoneImgView.image = [UIImage imageNamed:@"phone"];
    }
    return _phoneImgView;
}

- (UIImageView *)validateImgView
{
    if (!_validateImgView) {
        _validateImgView = [UIImageView new];
        _validateImgView.image = [UIImage imageNamed:@"yanzhengma"];
    }
    return _validateImgView;
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
        _usrTextView.placeholder = @"请输入您的手机号码";
        _usrTextView.delegate = self;
        _usrTextView.font = [UIFont sf_systemFontOfSize:13];
        _usrTextView.keyboardType = UIKeyboardTypeNumberPad;
        _usrTextView.clearButtonMode = UITextFieldViewModeWhileEditing;

    }
    return _usrTextView;
}

- (UITextField *)validateTextView
{
    if (!_validateTextView) {
        _validateTextView = [UITextField new];
        _validateTextView.placeholder = @"请输入验证码";
        _validateTextView.delegate = self;
        _validateTextView.font = [UIFont sf_systemFontOfSize:13];
        _validateTextView.adjustsFontSizeToFitWidth = YES;
        _validateTextView.minimumFontSize = 7;
        _validateTextView.keyboardType = UIKeyboardTypeNumberPad;
        _validateTextView.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _validateTextView;
}

- (UITextField *)pswTextView
{
    if (!_pswTextView) {
        _pswTextView = [UITextField new];
        _pswTextView.placeholder = @"请输入6-16位的密码";
        _pswTextView.delegate = self;
        _pswTextView.font = [UIFont systemFontOfSize:13];
        _pswTextView.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_pswTextView setSecureTextEntry:YES];
    }
    return _pswTextView;
}

- (UITextField *)rePswTextView
{
    if (!_rePswTextView) {
        _rePswTextView = [UITextField new];
        _rePswTextView.placeholder = @"请再次输入密码";
        _rePswTextView.delegate = self;
        _rePswTextView.font = [UIFont sf_systemFontOfSize:13];
        _rePswTextView.clearButtonMode = UITextFieldViewModeWhileEditing;
        [_rePswTextView setSecureTextEntry:YES];
    }
    return _rePswTextView;
}

- (UIButton *)getValidateBtn
{
    if (!_getValidateBtn) {
        _getValidateBtn = [UIButton new];
        [_getValidateBtn addTarget:self action:@selector(getValidateBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_getValidateBtn setBackgroundImage:[UIImage imageNamed:@"btnBg"] forState:UIControlStateNormal];
        [_getValidateBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_getValidateBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _getValidateBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
        _getValidateBtn.titleLabel.minimumScaleFactor = 0.5;
        [_getValidateBtn.titleLabel setFont:[UIFont sf_systemFontOfSize:13]];
        _getValidateBtn.layer.masksToBounds = YES;
        _getValidateBtn.layer.cornerRadius = CurrentDeviceSize(5);
    }
    return _getValidateBtn;
}

- (UIButton *)pswVisableBtn
{
    if (!_pswVisableBtn) {
        _pswVisableBtn = [UIButton new];
        [_pswVisableBtn addTarget:self action:@selector(pswVisableBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_pswVisableBtn setImage:[UIImage imageNamed:@"bukejian"] forState:UIControlStateNormal];
        [_pswVisableBtn setImage:[UIImage imageNamed:@"kejian"] forState:UIControlStateSelected];
    }
    return _pswVisableBtn;
}

- (UIButton *)rePswVisableBtn
{
    if (!_rePswVisableBtn) {
        _rePswVisableBtn = [UIButton new];
        [_rePswVisableBtn addTarget:self action:@selector(rePswVisableBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_rePswVisableBtn setImage:[UIImage imageNamed:@"bukejian"] forState:UIControlStateNormal];
        [_rePswVisableBtn setImage:[UIImage imageNamed:@"kejian"] forState:UIControlStateSelected];
    }
    return _rePswVisableBtn;
}

- (UIButton *)registerBtn
{
    if (!_registerBtn) {
        _registerBtn = [UIButton new];
        [_registerBtn addTarget:self action:@selector(registerBtnCilcked) forControlEvents:UIControlEventTouchUpInside];
        [_registerBtn.titleLabel setFont:[UIFont sf_systemFontOfSize:16]];
        [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _registerBtn.layer.masksToBounds = YES;
        _registerBtn.layer.cornerRadius = 5;
        [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
        _registerBtn.layer.masksToBounds = YES;
        _registerBtn.layer.cornerRadius = CurrentDeviceSize(5);
        [_registerBtn setBackgroundColor:[UIColor clearColor]];
        [_registerBtn setBackgroundImage:[UIImage imageNamed:@"btnBg"] forState:UIControlStateNormal];
        _registerBtn.enabled = NO;
    }
    return _registerBtn;
}

- (UIView *)userSepLine
{
    if (!_userSepLine) {
        _userSepLine = [UIView new];
        _userSepLine.backgroundColor = [UIColor lightGrayColor];
    }
    return _userSepLine;
}

- (UIView *)validateSepLine
{
    if (!_validateSepLine) {
        _validateSepLine = [UIView new];
        _validateSepLine.backgroundColor = [UIColor lightGrayColor];
    }
    return _validateSepLine;
}

- (UIView *)pswSepLine
{
    if (!_pswSepLine) {
        _pswSepLine = [UIView new];
        _pswSepLine.backgroundColor = [UIColor lightGrayColor];
    }
    return _pswSepLine;
}

- (UIView *)repswSepLine
{
    if (!_repswSepLine) {
        _repswSepLine = [UIView new];
        _repswSepLine.backgroundColor = [UIColor lightGrayColor];
    }
    return _repswSepLine;
}
@end
