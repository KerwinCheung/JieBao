//
//  BuYangYeJiaoZhunViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/5/3.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "BuYangYeJiaoZhunViewController.h"

@interface BuYangYeJiaoZhunViewController ()<GizWifiDeviceDelegate>

@property (nonatomic, strong) UILabel *subLb;

@property (nonatomic, strong) UIView *subBgView;

@property (nonatomic, strong) UITextField *subValueText;

@property (nonatomic, strong) UIView *mainBgView;

@property (nonatomic, strong) UILabel *timeLb;

@property (nonatomic, strong) UILabel *timeValueLb;

@property (nonatomic, strong) UIView *sepline1;

@property (nonatomic, strong) UILabel *channelLb;

@property (nonatomic, strong) UILabel *channelValueLb;

@property (nonatomic, strong) UIView *sepline2;

@property (nonatomic, strong) UILabel *startlb;

@property (nonatomic, strong) UISwitch *startSwitch;

@property (nonatomic, strong) UIButton *upBtn;

@property (nonatomic, strong) UIButton *downBtn;

@end

@implementation BuYangYeJiaoZhunViewController

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UICOLORFROMRGB(0xededed);
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
    ActionBlock rightAction = ^(UIButton *btn){
        [weakself save];
    };
    [self.naviBar  configNavigationBarWithAttrs:@{
                                                  kCustomNaviBarLeftActionKey:leftAction,
                                                  kCustomNaviBarLeftImgKey:@"back",
                                                  kCustomNaviBarTitleKey:@"补养液校准",
                                                  kCustomNaviBarRightImgKey:@"保存",
                                                  kCustomNaviBarRightActionKey:rightAction
                                                  }];
}

- (void)initUI
{
    [self.bgView addSubview:self.subLb];
    [self.bgView addSubview:self.subBgView];
    [self.subBgView addSubview:self.subValueText];
    
    [self.bgView addSubview:self.mainBgView];
    [self.mainBgView addSubview:self.timeLb];
    [self.mainBgView addSubview:self.timeValueLb];
    [self.mainBgView addSubview:self.sepline1];
    [self.mainBgView addSubview:self.channelLb];
    [self.mainBgView addSubview:self.channelValueLb];
    [self.mainBgView addSubview:self.sepline2];
    [self.mainBgView addSubview:self.startlb];
    [self.mainBgView addSubview:self.startSwitch];
    [self.mainBgView addSubview:self.upBtn];
    [self.mainBgView addSubview:self.downBtn];
    
    [self makeContraints];
}

- (void)makeContraints
{
    LHWeakSelf(self)
    [self.subLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@(CurrentDeviceSize(20)));
        make.width.lessThanOrEqualTo(@200);
    }];
    
    [self.subBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(weakself.subLb.mas_bottom).offset(CurrentDeviceSize(5));
        make.height.equalTo(@(CurrentDeviceSize(40)));
    }];
    
    [self.subValueText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.subLb);
        make.top.bottom.right.equalTo(@0);
    }];
    
    [self.mainBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(weakself.subBgView.mas_bottom).offset(CurrentDeviceSize(40));
        make.height.equalTo(@(CurrentDeviceSize(160)));
    }];
    
    [self.timeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.subLb);
        make.top.equalTo(@0);
        make.height.equalTo(@(CurrentDeviceSize(40)));
        make.width.lessThanOrEqualTo(@200);
    }];
    
    [self.timeValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.mainBgView.mas_right).offset(-CurrentDeviceSize(20));
        make.top.equalTo(@0);
        make.height.equalTo(@(CurrentDeviceSize(40)));
        make.width.lessThanOrEqualTo(@200);
    }];
    
    [self.sepline1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(10)));
        make.top.equalTo(weakself.timeLb.mas_bottom);
        make.height.equalTo(@(CurrentDeviceSize(0.5)));
        make.right.equalTo(weakself.mainBgView.mas_right).offset(-CurrentDeviceSize(10));
    }];
    
    [self.channelLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.subLb);
        make.top.equalTo(weakself.timeLb.mas_bottom);
        make.height.equalTo(@(CurrentDeviceSize(80)));
        make.width.lessThanOrEqualTo(@200);
    }];
    
    [self.upBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.mainBgView.mas_right).offset(-CurrentDeviceSize(20));
        make.centerY.equalTo(weakself.channelLb.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(20), CurrentDeviceSize(20)));
    }];
    
    [self.channelValueLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.upBtn.mas_left).offset(-CurrentDeviceSize(10));
        make.top.equalTo(weakself.channelLb);
        make.height.equalTo(@(CurrentDeviceSize(80)));
        make.width.lessThanOrEqualTo(@200);
    }];
    
    [self.downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.channelValueLb.mas_left).offset(-CurrentDeviceSize(10));
        make.centerY.equalTo(weakself.channelLb.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(20), CurrentDeviceSize(20)));
    }];
    
    [self.sepline2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(10)));
        make.top.equalTo(weakself.channelLb.mas_bottom);
        make.height.equalTo(@(CurrentDeviceSize(0.5)));
        make.right.equalTo(weakself.mainBgView.mas_right).offset(-CurrentDeviceSize(10));
    }];
    
    [self.startlb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.subLb);
        make.top.equalTo(weakself.channelLb.mas_bottom);
        make.height.equalTo(@(CurrentDeviceSize(40)));
        make.width.lessThanOrEqualTo(@200);
    }];
    
    [self.startSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.mainBgView.mas_right).offset(-CurrentDeviceSize(20));
        make.top.equalTo(weakself.startlb.mas_top).offset(CurrentDeviceSize(5));
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(40), CurrentDeviceSize(20)));
    }];
    
}

- (void)save
{
    self.dev.delegate = self;
    NSString *channelStr = [NSString stringWithFormat:@"channe%@",self.channelValueLb.text];
    NSString *liguidStr  = [NSString stringWithFormat:@"liquid%@",self.channelValueLb.text];
    [self.dev write:@{channelStr:@(self.startSwitch.selected),liguidStr:self.subValueText.text} withSN:111];
    
}

- (void)upBtnClicked
{
    self.channelValueLb.text = [NSString stringWithFormat:@"%ld",self.channelValueLb.text.integerValue + 1];
}

- (void)downBtnClicked
{
    self.channelValueLb.text = [NSString stringWithFormat:@"%ld",self.channelValueLb.text.integerValue - 1 <= 0 ? 0 : self.channelValueLb.text.integerValue - 1];
}

- (void)startSwitchChange
{
    
}

- (void)device:(GizWifiDevice *)device didReceiveData:(NSError *)result data:(NSDictionary<NSString *,id> *)dataMap withSN:(NSNumber *)sn
{
    if (result.code == GIZ_SDK_SUCCESS) {
        if ([sn integerValue] == 111) {
            [self alertShowMessage:@"保存成功" title:@"提示" confirmBtnText:@"确定" confirmCallback:nil];
        }
    }else
    {
        [self alertShowMessage:@"保存失败" title:@"提示" confirmBtnText:@"确定" confirmCallback:nil];
    }
}

- (UILabel *)subLb
{
    if (!_subLb) {
        _subLb = [UILabel new];
        _subLb.font = [UIFont sf_systemFontOfSize:13];
        _subLb.textAlignment = NSTextAlignmentLeft;
    }
    return _subLb;
}

- (UIView *)subBgView
{
    if (!_subBgView) {
        _subBgView = [UIView new];
        _subBgView.backgroundColor  = [UIColor whiteColor];
    }
    return _subBgView;
}

- (UITextField *)subValueText
{
    if (!_subValueText) {
        _subValueText = [UITextField new];
        _subValueText.font = [UIFont sf_systemFontOfSize:13];
        _subValueText.placeholder = @"请输入校准补养液量";
        _subValueText.textAlignment = NSTextAlignmentLeft;
    }
    return _subValueText;
}

- (UIView *)mainBgView
{
    if (!_mainBgView) {
        _mainBgView = [UIView new];
        _mainBgView.backgroundColor  = [UIColor whiteColor];
    }
    return _mainBgView;
}

- (UILabel *)timeLb
{
    if (!_timeLb) {
        _timeLb = [UILabel new];
        _timeLb.font = [UIFont sf_systemFontOfSize:13];
        _timeLb.textAlignment = NSTextAlignmentLeft;
        _timeLb.text = @"补养液校准时长";
    }
    return _timeLb;
}

- (UILabel *)timeValueLb
{
    if (!_timeValueLb) {
        _timeValueLb = [UILabel new];
        _timeValueLb.font = [UIFont sf_systemFontOfSize:13];
        _timeValueLb.text = [NSString stringWithFormat:@"%ld S",self.time.integerValue];
        _timeValueLb.textAlignment = NSTextAlignmentRight;
    }
    return _timeValueLb;
}

- (UIView *)sepline1
{
    if (!_sepline1) {
        _sepline1 = [UIView new];
        _sepline1.backgroundColor  = [UIColor lightGrayColor];
    }
    return _sepline1;
}

- (UILabel *)channelLb
{
    if (!_channelLb) {
        _channelLb = [UILabel new];
        _channelLb.font = [UIFont sf_systemFontOfSize:13];
        _channelLb.textAlignment = NSTextAlignmentLeft;
        _channelLb.text = @"补养液校准通道";
    }
    return _channelLb;
}

- (UILabel *)channelValueLb
{
    if (!_channelValueLb) {
        _channelValueLb = [UILabel new];
        _channelValueLb.font = [UIFont sf_systemFontOfSize:13];
        _channelValueLb.text = @"1";
        _channelValueLb.textAlignment = NSTextAlignmentRight;
    }
    return _channelValueLb;
}

- (UIView *)sepline2
{
    if (!_sepline2) {
        _sepline2 = [UIView new];
        _sepline2.backgroundColor  = [UIColor lightGrayColor];
    }
    return _sepline2;
}

- (UILabel *)startlb
{
    if (!_startlb) {
        _startlb = [UILabel new];
        _startlb.font = [UIFont sf_systemFontOfSize:13];
        _startlb.textAlignment = NSTextAlignmentLeft;
        _startlb.text = @"补养液校准开启";
    }
    return _startlb;
}

- (UISwitch *)startSwitch
{
    if (!_startSwitch) {
        _startSwitch = [UISwitch new];
        [_startSwitch addTarget:self action:@selector(startSwitchChange) forControlEvents:UIControlEventValueChanged];
    }
    return _startSwitch;
}

- (UIButton *)upBtn
{
    if (!_upBtn) {
        _upBtn = [UIButton new];
        [_upBtn addTarget:self action:@selector(upBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_upBtn setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    }
    return _upBtn;
}

- (UIButton *)downBtn
{
    if (!_downBtn) {
        _downBtn = [UIButton new];
        [_downBtn addTarget:self action:@selector(downBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_downBtn setImage:[UIImage imageNamed:@"next1"] forState:UIControlStateNormal];
    }
    return _downBtn;
}
@end
