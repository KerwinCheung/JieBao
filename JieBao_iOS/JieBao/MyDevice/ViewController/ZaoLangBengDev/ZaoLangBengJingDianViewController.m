//
//  ZaoLangBengJingDianViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/6/19.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "ZaoLangBengJingDianViewController.h"
#import "SliderView.h"

@interface ZaoLangBengJingDianViewController ()

@property (nonatomic, strong) UISegmentedControl *segCon;

@property (nonatomic, strong) SliderView *flowView;

@property (nonatomic, strong) SliderView *frequencyView;

@end

@implementation ZaoLangBengJingDianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bgView.backgroundColor = UICOLORFROMRGB(0xf0f0f0);
    [self.bgView addSubview:self.segCon];
    [self.bgView addSubview:self.flowView];
    [self.bgView addSubview:self.frequencyView];
    
    LHWeakSelf(self);
    [self.segCon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.bgView);
        make.top.mas_equalTo(CurrentDeviceSize(20));
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(140), CurrentDeviceSize(20)));
    }];
    
    [self.flowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(weakself.segCon.mas_bottom).offset(CurrentDeviceSize(20));
        make.height.mas_equalTo(CurrentDeviceSize(70));
    }];
    
    [self.frequencyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(weakself.flowView.mas_bottom).offset(CurrentDeviceSize(20));
        make.height.mas_equalTo(weakself.flowView);
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
                                                  kCustomNaviBarTitleKey:@"经典造浪模式",
                                                  kCustomNaviBarRightImgKey:@"保存",
                                                  kCustomNaviBarRightActionKey:rightAction
                                                  }];
}

- (void)save
{
    
}

- (void)segConValueChange
{
    
}

- (UISegmentedControl *)segCon
{
    if (!_segCon) {
        _segCon = [[UISegmentedControl alloc] initWithItems:@[@"同步控制",@"异步控制"]];
        [_segCon addTarget:self action:@selector(segConValueChange) forControlEvents:UIControlEventValueChanged];
    }
    return _segCon;
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
@end
