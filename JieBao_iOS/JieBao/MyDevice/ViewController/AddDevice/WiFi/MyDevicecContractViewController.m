//
//  DeviceConnectViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/17.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//  配网loading

#import "MyDevicecContractViewController.h"

@interface MyDevicecContractViewController ()

@property (nonatomic, strong) UILabel *timelb;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger timeCount;

@property (nonatomic, strong) UIImageView *loadImgView;

@property (nonatomic, strong) LoadingHelper *helper;

@end

@implementation MyDevicecContractViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.timeCount = 120;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UICOLORFROMRGB(0xededed);
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self.view addSubview:self.timelb];
    [self.view addSubview:self.loadImgView];
    self.timelb.text = [NSString stringWithFormat:@"设备连接中 %ld",self.timeCount];
    [self makeContraints];
    [self contract];
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

- (void)makeContraints
{
    LHWeakSelf(self)
    [self.timelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.width.lessThanOrEqualTo(@(CurrentDeviceSize(200)));
        make.centerY.equalTo(weakself.view.mas_centerY);
    }];
    
    [self.loadImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.bottom.equalTo(weakself.timelb.mas_top).offset(-CurrentDeviceSize(10));
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(80), CurrentDeviceSize(80)));
    }];
}

- (void)dealloc
{
    [self dismiss];
}

- (void)contract
{
    LHWeakSelf(self)
     [self.helper showLoadingInView:self.loadImgView];
    [[GizWifiSDK sharedInstance] setDeviceOnboarding:self.ssid key:self.key configMode:GizWifiAirLink softAPSSIDPrefix:nil timeout:60 wifiGAgentType:[NSArray arrayWithObjects: @(GizGAgentESP), nil]];
    [SDKHelper shareInstance].onboardingCallBackBlock = ^(BOOL success) {
        if (success) {
            LHLog(@"链接成功");
            [UtilHelper setWifiLocalize:@{kUserWIFINameKey:self.ssid,kUserWIFIPSWKey:self.key}];
            [weakself dismiss];
            [weakself.navigationController pushViewController:[NSClassFromString(@"MyDeviceAddDeviceViewController") new] animated:YES];
        }else
        {
             [weakself.navigationController pushViewController:[NSClassFromString(@"MyDevicecContractErrorViewController") new] animated:YES];
        }
    };
}

- (void)dismiss
{
    [self.helper dismissLoading];
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    self.timelb.hidden = YES;
}

- (void)timerCount
{
    self.timelb.text = [NSString stringWithFormat:@"设备连接中 %ld",self.timeCount--];
    if (self.timeCount == 0) {
        self.timeCount = 120;
        [self.helper dismissLoading];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.navigationController pushViewController:[NSClassFromString(@"MyDeviceAddDeviceViewController") new] animated:YES];
}

#pragma mark - lazy init
- (UILabel *)timelb
{
    if (!_timelb) {
        _timelb = [UILabel new];
        _timelb.font = [UIFont sf_systemFontOfSize:13];
        _timelb.hidden = NO;
    }
    return _timelb;
}

- (NSTimer *)timer
{
    if (!_timer) {
        _timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerCount) userInfo:nil repeats:YES];
    }
    return _timer;
}

- (UIImageView *)loadImgView
{
    if (!_loadImgView) {
        _loadImgView = [UIImageView new];
    }
    return _loadImgView;
}

- (LoadingHelper *)helper
{
    if (!_helper) {
        _helper = [LoadingHelper new];
    }
    return _helper;
}
@end
