//
//  ZaoLangBengJingDianViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/6/19.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "ZaoLangBengZhengXianViewController.h"
#import "SliderView.h"
#import "TimingChartView.h"

@interface ZaoLangBengZhengXianViewController ()

@property (nonatomic, strong) SliderView *flowView;

@property (nonatomic, strong) SliderView *frequencyView;

@property (nonatomic, strong) TimingChartView *lineChartView;
@end

@implementation ZaoLangBengZhengXianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bgView.backgroundColor = UICOLORFROMRGB(0xf0f0f0);
    [self.bgView addSubview:self.flowView];
    [self.bgView addSubview:self.frequencyView];
    
    LHWeakSelf(self);
    [self.flowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(@(CurrentDeviceSize(20)));
        make.height.mas_equalTo(CurrentDeviceSize(70));
    }];
    
    [self.frequencyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(weakself.flowView.mas_bottom).offset(CurrentDeviceSize(20));
        make.height.mas_equalTo(weakself.flowView);
    }];
    
    [self.lineChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(weakself.frequencyView.mas_bottom).offset(CurrentDeviceSize(20));
        make.height.mas_equalTo(CurrentDeviceSize(200));
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
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
                                                  kCustomNaviBarTitleKey:@"正弦造浪模式",
                                                  kCustomNaviBarRightImgKey:@"保存",
                                                  kCustomNaviBarRightActionKey:rightAction
                                                  }];
}

- (void)save
{
    
}

- (SliderView *)flowView
{
    if (!_flowView) {
        _flowView = [SliderView new];
        _flowView.title = @"Flow";
    }
    return _flowView;
}

- (SliderView *)frequencyView
{
    if (!_frequencyView) {
        _frequencyView = [SliderView new];
        _frequencyView.title = @"Frequency";
    }
    return _frequencyView;
}

- (TimingChartView *)lineChartView
{
    if (!_lineChartView) {
        _lineChartView = [TimingChartView new];
        _lineChartView.delegate = self;
        [_lineChartView setSelectedIndex:0];
    }
    return _lineChartView;
}
@end
