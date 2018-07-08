//
//  DeviceConnectViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/17.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "MyDeviceConnectViewController.h"

@interface MyDeviceConnectViewController ()

@property (nonatomic, strong) UILabel *timelb;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger timeCount;

@end

@implementation MyDeviceConnectViewController

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
    
    LHWeakSelf(self)
    [self.timelb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.width.lessThanOrEqualTo(@(CurrentDeviceSize(200)));
        make.centerY.equalTo(weakself.view.mas_centerY);
    }];
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
                                                  kCustomNaviBarTitleKey:@"设备连接",
                                                  }];
}

- (void)dealloc
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)timerCount
{
    self.timelb.text = [NSString stringWithFormat:@"设备连接中 %ld",self.timeCount--];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.navigationController pushViewController:[NSClassFromString(@"TurnViewController") new] animated:YES];
}

- (UILabel *)timelb
{
    if (!_timelb) {
        _timelb = [UILabel new];
        _timelb.font = [UIFont sf_systemFontOfSize:13];
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
@end

