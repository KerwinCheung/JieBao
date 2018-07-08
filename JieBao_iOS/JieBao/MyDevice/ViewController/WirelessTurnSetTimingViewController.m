//
//  IntervalTimeViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/5/14.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "WirelessTurnSetTimingViewController.h"

@interface WirelessTurnSetTimingViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UILabel *startTimeLb;

@property (nonatomic, strong) UIPickerView *pView;

@end

@implementation WirelessTurnSetTimingViewController

- (instancetype)init
{
    if (self = [super init]) {
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bgView.backgroundColor = UICOLORFROMRGB(0xededed);
    [self ininUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    LHWeakSelf(self)
    ActionBlock rightAction = ^(UIButton *btn){
        [weakself save];
        LHLog(@"保存");
    };
    
    ActionBlock leftAction = ^(UIButton *btn){
        [weakself.navigationController popViewControllerAnimated:YES];
        LHLog(@"left");
    };
    [self.naviBar  configNavigationBarWithAttrs:@{
                                                  kCustomNaviBarLeftActionKey:leftAction,
                                                  kCustomNaviBarLeftImgKey:@"back",
                                                  kCustomNaviBarTitleKey:@"设置时间段",
                                                  kCustomNaviBarRightImgKey:@"保存",
                                                  kCustomNaviBarRightActionKey:rightAction
                                                  }];
}

- (void)ininUI
{
    
    [self.bgView addSubview:self.startTimeLb];
    [self.bgView addSubview:self.pView];
    
    LHWeakSelf(self)
    
    [self.startTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(CurrentDeviceSize(40)));
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.width.lessThanOrEqualTo(@200);
    }];
    
    [self.pView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.startTimeLb.mas_bottom);
        make.left.right.equalTo(@0);
        make.height.equalTo(@(CurrentDeviceSize(200)));
    }];
}

- (void)save
{
    GizDeviceScheduler *scheduler = [GizDeviceScheduler schedulerOneTime:@{@"LED_OnOff": @YES} date:@"2017-01-16" time:@"06:30" enabled:YES remark:@"一次性开灯任务"];
    
    // 创建设备定时任务，mDevice为在设备列表中得到的设备对象
    [GizDeviceSchedulerCenter createScheduler:[UserHelper getCurrentUser].uid token:[UserHelper getCurrentUser].token schedulerOwner:self.dev scheduler:scheduler schedulerTasks:nil];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView

{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return component == 0 ? 24 : 60;;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%ld",row];;
}

- (UILabel *)startTimeLb
{
    if (!_startTimeLb) {
        _startTimeLb = [UILabel new];
        _startTimeLb.text = @"请选择开始时间";
        _startTimeLb.font = [UIFont sf_systemFontOfSize:13];
        _startTimeLb.textAlignment = NSTextAlignmentLeft;
    }
    return _startTimeLb;
}

- (UIPickerView *)pView
{
    if (!_pView) {
        _pView = [UIPickerView new];
        _pView.backgroundColor = [UIColor whiteColor];
        _pView.delegate = self;
        _pView.dataSource = self;
    }
    return _pView;
}

@end
