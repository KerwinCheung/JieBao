//
//  LoginViewController.m
//  JieBao
//
//  Created by wen on 2018/4/12.
//  Copyright © 2018年 wen. All rights reserved.
//

#import "LoginViewController.h"
#import "UIViewController+Custom.h"
#import "SettingViewController.h"

#import "LocalizedEngine.h"
#import "LWHttpRequest.h"
#import "AppDelegate.h"

#import "IQKeyboardManager.h"

@interface LoginViewController ()<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *PhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIView *pwdView;

@property (weak, nonatomic) IBOutlet UIButton *eyeBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgotPwdBtn;


@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.loginBtn.backgroundColor = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1];
    
    @weakify(self);
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note){
        @strongify(self);
        if ([note.object isEqual:self.PhoneTextField])
        {
            if ([UtilHelper isValidateMobile:self.PhoneTextField.text]) {
                self.loginBtn.enabled = YES;
                [self.loginBtn setBackgroundImage:[UIImage imageNamed:@"button1"] forState:UIControlStateNormal];
            }else{
                self.loginBtn.enabled = NO;
                [self.loginBtn setBackgroundImage:nil forState:UIControlStateNormal];
            }
        }
    }];
}

- (void)applicationWillEnterForeground{
    [self.view endEditing:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar= YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];

    [super viewWillAppear:animated];
    self.PhoneTextField.text = [UserHelper getCurrentUser].userName;
    self.pwdTextField.text = [UserHelper getCurrentUser].psw;
    if (self.PhoneTextField.text.length > 0 && self.pwdTextField.text.length >0) {
        self.loginBtn.enabled = YES;
    }else{
        self.loginBtn.enabled = NO;
        [self.loginBtn setBackgroundImage:nil forState:UIControlStateNormal];
    }

    [self registerNoti];
    NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
    [self.navigationController setNavigationBarHidden:NO animated:NO];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)registerNoti{
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldChanged) name:UITextFieldTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name: UIKeyboardWillShowNotification object:nil];

    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name: UIKeyboardWillHideNotification object:nil];
}


#pragma mark - UI事件
- (IBAction)eyeBtnClicked:(id)sender {
    UIButton *btn = (UIButton *)sender;
    btn.selected = !btn.selected;
    self.pwdTextField.secureTextEntry = !btn.selected;
    
}
- (IBAction)loginBtnClicked:(id)sender {
    [self loginBtnCilcked];
}

- (IBAction)registerBtnClicked:(id)sender {
    [self registerNewBtnClicked];
    
}
- (IBAction)forgotBtnclicked:(id)sender {
    [self fogotPswBtnClicked];
}

- (void)loginBtnCilcked
{
    LHWeakSelf(self)
    if (self.PhoneTextField.text.length != 11) {
        [HudHelper showErrorWithStatus:@"请输入正确手机号码"];
        return;
    }
    
    if (self.pwdTextField.text.length < 6 || self.pwdTextField.text.length > 16) {
        [HudHelper showErrorWithStatus:@"请输入6-16位密码"];

        return;
    }
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        if (status == AFNetworkReachabilityStatusNotReachable) {
            [HudHelper showErrorWithStatus:@"请检查网络设置"];
            return;
        }
    }];
    
    [SVProgressHUD show];
    [SDKHelper shareInstance].loginBlock = ^(BOOL success) {
        if (success) {
            UserModel *model = [UserHelper getCurrentUser];
            model.userName = weakself.PhoneTextField.text;
            model.psw = weakself.pwdTextField.text;
            [UserHelper setCurrentUser:model];
            
            [LWHttpRequest getGroupListDidLoadData:^(NSArray *result, NSError *err) {
                if (!err) {
                    SDKHELPER.groupsArray = [NSMutableArray arrayWithArray:result];
                    dispatch_group_t dispatchGroup = dispatch_group_create();
                    //获取队列
                    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
                    //添加并发任务
                    for (CustomDeviceGroup *group in result) {
                        if ([group isKindOfClass:[CustomDeviceGroup class]]) {
                            //获取分组详情
                            dispatch_group_async(dispatchGroup, queue, ^{
                                [LWHttpRequest getGroupDetailsWithGroup:group didLoadData:^(id result, NSError *err) {
                                    if (err) {
                                        NSLog(@"获取分组详情失败 分组id:%@",group.gid);
                                    }else{
                                        [SDKHELPER addGroupToLocalWith:group];
                                    }
                                }];
                            });
                            
                        }
                    }

                    //任务执行完毕后，获取通知
                    dispatch_group_notify(dispatchGroup, queue, ^{
                        [SVProgressHUD dismiss];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            AppDelegate *delegate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
                            [delegate changeRootViewController];
                        });
                    });

                }else{
                    [SVProgressHUD dismiss];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        AppDelegate *delegate =  (AppDelegate *)[[UIApplication sharedApplication] delegate];
                        [delegate changeRootViewController];
                    });
                }
            }];
        }else{
            [SVProgressHUD dismiss];
        }
    };
    [[GizWifiSDK sharedInstance] userLogin:self.PhoneTextField.text password:self.pwdTextField.text];
}

- (void)registerNewBtnClicked
{
    [self.navigationController pushViewController:[NSClassFromString(@"RegisterViewController") new] animated:YES];
}

- (void)fogotPswBtnClicked
{
    [self.navigationController pushViewController:[NSClassFromString(@"FogotPswViewController") new] animated:YES];
}


#pragma mark - 键盘事件监听
-(void)keyboardWasShown:(NSNotification *)noti{
    NSDictionary *info = [noti userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    float bottomY = self.view.frame.size.height-CGRectGetMaxY(self.pwdView.frame);
    if (bottomY<keyboardSize.height) {
        if (self.view.frame.origin.y == 0) {
            NSTimeInterval animationDuration = 0.30f;
            [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
            [UIView setAnimationDuration:animationDuration];

            float moveY = keyboardSize.height-bottomY;

            CGRect frame = self.view.frame;
            frame.origin.y -=moveY;//view的Y轴上移
            self.view.frame = frame;
            [UIView commitAnimations];//设置调整界面的动画效果
        }

    }
}
-(void)keyboardWasHidden:(NSNotification *)noti{
//    NSDictionary *info = [noti userInfo];
//    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
//    CGSize keyboardSize = [value CGRectValue].size;
//    float bottomY = self.view.frame.size.height-CGRectGetMaxY(self.pwdView.frame);
    //    float moveY = keyboardSize.height-bottomY;
    if (self.view.frame.origin.y<0) {
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        CGRect frame = self.view.frame;
        frame.origin.y=0;
        self.view.frame = frame;
        [UIView commitAnimations];//设置调整界面的动画效果
    }
}

#pragma mark - textField 监听
-(void)textFieldChanged{    
    if (_PhoneTextField.text.length>0 && _pwdTextField.text.length>0) {
        _loginBtn.enabled = YES;
    }else{
        _loginBtn.enabled = NO;
    }

    if (_PhoneTextField.text.length>11) {
        _PhoneTextField.text=[_PhoneTextField.text substringToIndex:11];
    }
    if (_pwdTextField.text.length>20) {
        _pwdTextField.text=[_pwdTextField.text substringToIndex:16];
    }
}

#pragma mark - textFieldDelegate
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.PhoneTextField resignFirstResponder];
    [self.pwdTextField resignFirstResponder];
}




@end
