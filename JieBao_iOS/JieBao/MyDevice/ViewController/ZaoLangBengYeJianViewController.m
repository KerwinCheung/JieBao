//
//  ZaoLangBengYeJianViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/6/19.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "ZaoLangBengYeJianViewController.h"
#import "TimingChartView.h"

@interface ZaoLangBengYeJianViewController ()

@property (nonatomic, strong) UILabel *subLb;

@property (nonatomic, strong) TimingChartView *lineChartView;

@end

@implementation ZaoLangBengYeJianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bgView.backgroundColor = UICOLORFROMRGB(0xf0f0f0);
    [self.bgView addSubview:self.subLb];
    [self.bgView addSubview:self.lineChartView];
    
    LHWeakSelf(self);
    [self.subLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(CurrentDeviceSize(20));
        make.top.mas_equalTo(CurrentDeviceSize(60));
        make.width.lessThanOrEqualTo(@200);
    }];
    
    [self.lineChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(weakself.subLb.mas_bottom).offset(CurrentDeviceSize(10));
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
                                                  kCustomNaviBarTitleKey:@"夜间模式",
                                                  kCustomNaviBarRightImgKey:@"保存",
                                                  kCustomNaviBarRightActionKey:rightAction
                                                  }];
}

- (void)save
{
    
}

- (UILabel *)subLb
{
    if (!_subLb) {
        _subLb = [UILabel new];
        _subLb.text = @"请在图表上设置流量值";
    }
    return _subLb;
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
