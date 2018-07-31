//
//  BaseViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/12.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "BaseViewController.h"


@interface BaseViewController ()

@property (nonatomic, strong, readwrite) UIView *bgView;

@property (nonatomic, strong, readwrite) BaseCustomNavigationBarView *naviBar;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.naviBar];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    LHLog(@"disappear:%@",NSStringFromClass([self class]));
}

- (void)dealloc
{
    LHLog(@"delloc:%@",NSStringFromClass([self class]));
}

#pragma mark - hud
-(void)showErrorWithStatusWhithCode:(GizWifiErrorCode)code {
    NSString *showString;
    switch (code) {
        case GIZ_SDK_DEVICE_NOT_READY:
            showString = @"设备未就绪";
            break;
        case GIZ_SDK_DEVICE_NOT_SUBSCRIBED:
            showString = @"设备未订阅";
            break;
        case GIZ_SDK_DEVICE_NO_RESPONSE:
            showString = @"设备未响应";
            break;
        case GIZ_SDK_DEVICE_GET_STATUS_FAILED:
            showString = @"设备状态查询失败";
            break;
            case GIZ_SDK_DEVICE_NOT_CENTERCONTROL:
            showString = @"设备不是终控设备";
            break;
        default:
            showString = @"设备状态错误";
            break;
    }
    [HudHelper showErrorWithStatus:showString];
}

#pragma mark - getter
- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, LL_StatusBarAndNavigationBarHeight, LL_ScreenWidth, LL_ScreenHeight - LL_StatusBarAndNavigationBarHeight)];
        _bgView.backgroundColor = [UIColor clearColor];
    }
    return _bgView;
}

- (BaseCustomNavigationBarView *)naviBar
{
    if (!_naviBar) {
        _naviBar = [[BaseCustomNavigationBarView alloc] initWithFrame:CGRectMake(0, 0, LL_ScreenWidth, LL_StatusBarAndNavigationBarHeight)];
    }
    return _naviBar;
}

@end
