//
//  ChannelTimingSettingViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/5/3.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "WirelessTurnSettingViewController.h"
#import "WirelessTurnDetailViewController.h"

@interface WirelessTurnSettingViewController ()

@property (nonatomic, strong) UILabel *subLb;

@property (nonatomic, strong) UIView *turnBgView;

@property (nonatomic, strong) UIButton *turnBtn;

@property (nonatomic, strong) UILabel *statusLb;

@property (nonatomic, strong) UIView *mainBgView;

@property (nonatomic, strong) UILabel *timingSettingLb;

@property (nonatomic, strong) UIButton *tranferImgBtn;

@property (nonatomic, strong) UIView *sepline;

@property (nonatomic, strong) UILabel *timingUseLb;

@property (nonatomic, strong) UISwitch *startSwitch;

@end

@implementation WirelessTurnSettingViewController

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.backgroundColor = UICOLORFROMRGB(0xededed);
    [self initUI];
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
                                                  kCustomNaviBarTitleKey:@"通道设置",
                                                  }];
}

- (void)initUI
{
    [self.bgView addSubview:self.subLb];
    [self.bgView addSubview:self.turnBgView];
    [self.turnBgView addSubview:self.turnBtn];
    [self.turnBgView addSubview:self.statusLb];
    [self.bgView addSubview:self.mainBgView];
    [self.mainBgView addSubview:self.timingSettingLb];
    [self.mainBgView addSubview:self.tranferImgBtn];
    [self.mainBgView addSubview:self.sepline];
    [self.mainBgView addSubview:self.timingUseLb];
    [self.mainBgView addSubview:self.startSwitch];
    
    LHWeakSelf(self)
    
    [self.subLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.top.equalTo(@(CurrentDeviceSize(20)));
        make.width.lessThanOrEqualTo(@200);
    }];
    
    [self.turnBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(weakself.subLb.mas_bottom);
        make.height.equalTo(weakself.bgView.mas_height).multipliedBy(0.4);
    }];
    
    [self.turnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.bgView);
        make.top.equalTo(@(CurrentDeviceSize(20)));
        make.bottom.equalTo(weakself.statusLb.mas_top);
    }];
    
    [self.statusLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.bgView);
        make.width.lessThanOrEqualTo(@200);
        make.bottom.equalTo(@0);
    }];
    
    [self.mainBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(weakself.turnBgView.mas_bottom).offset(CurrentDeviceSize(20));
        make.height.equalTo(@(2*CurrentDeviceSize(44)));
    }];
    
    [self.timingSettingLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.top.equalTo(@0);
        make.bottom.equalTo(weakself.mainBgView.mas_centerY);
        make.width.lessThanOrEqualTo(@100);
    }];
    
    [self.tranferImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.bgView.mas_right).offset(-CurrentDeviceSize(20));
        make.centerY.equalTo(weakself.timingSettingLb.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(20), CurrentDeviceSize(20)));;
    }];
    
    [self.sepline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(10)));
        make.top.equalTo(weakself.mainBgView.mas_centerY);
        make.height.equalTo(@(CurrentDeviceSize(0.5)));
        make.right.equalTo(weakself.mainBgView.mas_right).offset(-CurrentDeviceSize(10));
    }];
    
    [self.timingUseLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.top.equalTo(weakself.mainBgView.mas_centerY);
        make.bottom.equalTo(@0);
        make.width.lessThanOrEqualTo(@100);
    }];
    
    [self.startSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.bgView.mas_right).offset(-CurrentDeviceSize(20));
        make.centerY.equalTo(weakself.timingUseLb.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(40), CurrentDeviceSize(20)));;
    }];
    
    
}

- (void)turnBtnClicked
{
    
}

- (void)tranferImgBtnClicked
{
    WirelessTurnDetailViewController *vc = [WirelessTurnDetailViewController new];
    vc.dev = self.dev;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)startSwitchChange
{
   
}


- (UILabel *)subLb
{
    if (!_subLb) {
        _subLb = [UILabel new];
        _subLb.text = @"请选择手动或设置定时";
        _subLb.font = [UIFont sf_systemFontOfSize:13];
        _subLb.textAlignment = NSTextAlignmentLeft;
    }
    return _subLb;
}

- (UIView *)turnBgView
{
    if (!_turnBgView) {
        _turnBgView = [UIView new];
        _turnBgView.backgroundColor = [UIColor whiteColor];
    }
    return _turnBgView;
}


- (UIButton *)turnBtn
{
    if (!_turnBtn) {
        _turnBtn = [UIButton new];
        [_turnBtn addTarget:self action:@selector(turnBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_turnBtn setImage:[UIImage imageNamed:@"open"] forState:UIControlStateNormal];
    }
    return _turnBtn;
}

- (UILabel *)statusLb
{
    if (!_statusLb) {
        _statusLb = [UILabel new];
        _statusLb.text = @"当前状态: 开启";
        _statusLb.font = [UIFont sf_systemFontOfSize:11];
        _statusLb.textAlignment = NSTextAlignmentLeft;
    }
    return _statusLb;
}

- (UIView *)mainBgView
{
    if (!_mainBgView) {
        _mainBgView = [UIView new];
        _mainBgView.backgroundColor = [UIColor whiteColor];
    }
    return _mainBgView;
}

- (UILabel *)timingSettingLb
{
    if (!_timingSettingLb) {
        _timingSettingLb = [UILabel new];
        _timingSettingLb.text = @"定时设置";
        _timingSettingLb.font = [UIFont sf_systemFontOfSize:13];
        _timingSettingLb.textAlignment = NSTextAlignmentLeft;
    }
    return _timingSettingLb;
}

- (UIButton *)tranferImgBtn
{
    if (!_tranferImgBtn) {
        _tranferImgBtn = [UIButton new];
        [_tranferImgBtn setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
        [_tranferImgBtn addTarget:self action:@selector(tranferImgBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tranferImgBtn;
}

- (UIView *)sepline
{
    if (!_sepline) {
        _sepline = [UIView new];
        _sepline.backgroundColor  = [UIColor lightGrayColor];
    }
    return _sepline;
}

- (UILabel *)timingUseLb
{
    if (!_timingUseLb) {
        _timingUseLb = [UILabel new];
        _timingUseLb.text = @"定时启用";
        _timingUseLb.font = [UIFont sf_systemFontOfSize:13];
        _timingUseLb.textAlignment = NSTextAlignmentLeft;
    }
    return _timingUseLb;
}

- (UISwitch *)startSwitch
{
    if (!_startSwitch) {
        _startSwitch = [UISwitch new];
        [_startSwitch addTarget:self action:@selector(startSwitchChange) forControlEvents:UIControlEventValueChanged];
    }
    return _startSwitch;
}

@end
