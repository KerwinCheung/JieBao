//
//  CaiDengNightTypeViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/20.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "CaiDengNightTypeViewController.h"
#import "LightsDataPointModel.h"
@interface CaiDengNightTypeViewController ()<GizWifiDeviceDelegate>

@property (nonatomic, strong) UIImageView *nightImgView;

@property (nonatomic, strong) UILabel *tiplb;

@property (nonatomic, strong) UIView *sliderBGView;

@property (nonatomic, strong) UILabel *settingNameLb;

@property (nonatomic, strong) UILabel *valuelb;

@property (nonatomic, strong) BaseSlider *slider;

@property (nonatomic, strong) UIButton *settingBtn;

@end

@implementation CaiDengNightTypeViewController

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UICOLORFROMRGB(0xededed);
    [self initUI];
    if (self.dev) {
        self.dev.delegate = self;
        [self.dev getDeviceStatus:@[@"M5"]];
    }else{
        //设置分组初始状态,使用某一台设备的状态
        for (CustomDevice *customDev in self.group.devs) {
            if ([SDKHELPER.statusDic.allKeys containsObject:customDev.did]) {
                LightsDataPointModel *lightStatusModel = [SDKHELPER.statusDic objectForKey:customDev.did];
                self.slider.value = lightStatusModel.M5Num.floatValue;
                self.valuelb.text = [NSString stringWithFormat:@"%ld%%",(NSInteger)self.slider.value];
                return;
            }
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    LHWeakSelf(self)
    ActionBlock leftAction = ^(UIButton *btn){
        [weakself.navigationController popViewControllerAnimated:YES];
        LHLog(@"left");
    };
    [self.naviBar  configNavigationBarWithAttrs:@{kCustomNaviBarLeftActionKey:leftAction,
                                                  kCustomNaviBarLeftImgKey:@"back",
                                                  kCustomNaviBarTitleKey:@"夜晚模式设置",}];
}

- (void)initUI
{
    [self.bgView addSubview:self.nightImgView];
    [self.bgView addSubview:self.tiplb];
    [self.bgView addSubview:self.sliderBGView];
    [self.sliderBGView addSubview:self.settingNameLb];
    [self.sliderBGView addSubview:self.valuelb];
    [self.sliderBGView addSubview:self.slider];
    [self.bgView addSubview:self.settingBtn];
    
    [self makeContraints];
}

- (void)makeContraints
{
    LHWeakSelf(self)
    
    [self.nightImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(@(CurrentDeviceSize(0)));
        make.height.equalTo(@(LL_ScreenHeight/3));
    }];
    
    [self.tiplb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.top.equalTo(weakself.nightImgView.mas_bottom).offset(CurrentDeviceSize(20));
        make.width.lessThanOrEqualTo(@300);
    }];
    
    [self.sliderBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(weakself.tiplb.mas_bottom).offset(CurrentDeviceSize(10));
        make.height.equalTo(@(CurrentDeviceSize(70)));
    }];
                            
    [self.settingNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.tiplb.mas_left);
        make.top.equalTo(@(CurrentDeviceSize(20)));
        make.width.lessThanOrEqualTo(@200);
    }];
    
    [self.slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.tiplb.mas_left);
        make.top.equalTo(weakself.settingNameLb.mas_bottom).offset(CurrentDeviceSize(5));
        make.height.equalTo(@(CurrentDeviceSize(10)));
        make.right.equalTo(weakself.view.mas_right).offset(-CurrentDeviceSize(20));
    }];
    
    [self.valuelb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(weakself.slider.mas_centerX);
         make.right.equalTo(weakself.sliderBGView.mas_right).offset(-CurrentDeviceSize(20));
        make.top.equalTo(@(CurrentDeviceSize(20)));
        make.width.lessThanOrEqualTo(@200);
    }];
    
    [self.settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(CurrentDeviceSize(35)));
        make.top.equalTo(weakself.sliderBGView.mas_bottom).offset(CurrentDeviceSize(40));
        make.width.equalTo(@(LL_ScreenWidth - 60));
        make.centerX.equalTo(weakself.view.mas_centerX);
    }];
    
}

#pragma mark slider ValueChanged
- (void)sliderValueChanged
{
    self.valuelb.text = [NSString stringWithFormat:@"%ld%%",(NSInteger)self.slider.value];
    [self settingBtnClicked];
}

- (void)settingBtnClicked
{
    if (self.dev) {
        float sliderValue = self.slider.value;
        [self.dev write:@{@"M5":@(sliderValue),@"Timer":@NO,@"mode":@(5)} withSN:105];
    }else{
        NSDictionary *body = @{@"attrs":@{@"M5":@(self.slider.value),@"Timer":@NO,@"mode":@(5)}};
        [NetworkHelper sendRequest:body Method:@"POST" Path:[NSString stringWithFormat:@"https://api.gizwits.com/app/group/%@/control",self.group.gid] callback:^(NSData *data, NSError *error) {
            if (!data || error) {
                [HudHelper showErrorWithStatus:@"设置失败"];
                return ;
            }
//            [HudHelper showSuccessWithStatus:@"设置成功"];
        }];
    }
}

    
#pragma mark - 
- (void)device:(GizWifiDevice *)device didReceiveData:(NSError *)result data:(NSDictionary<NSString *,id> *)dataMap withSN:(NSNumber *)sn
{
    if (result.code == GIZ_SDK_SUCCESS) {
        if (self.dev && sn.integerValue == 0) {
            NSDictionary *data = dataMap[@"data"];
            self.slider.value = [[data objectForKey:@"M5"] floatValue];
            self.valuelb.text = [NSString stringWithFormat:@"%ld%%",(NSInteger)self.slider.value];
            return;
        }
        
        if ([sn integerValue] == 105) {
//            [HudHelper showSuccessWithStatus:@"设置成功"];
        }
    }else{
        if ([sn integerValue] == 101) {
            [HudHelper showSuccessWithStatus:@"设置失败"];
            return;
        }
        [self showErrorWithStatusWhithCode:result.code];
    }
}




#pragma mark - lazy init
- (UIImageView *)nightImgView
{
    if (!_nightImgView) {
        _nightImgView = [UIImageView new];
        _nightImgView.image = [UIImage imageNamed:@"pic3"];
    }
    return _nightImgView;
}

- (UILabel *)tiplb
{
    if (!_tiplb) {
        _tiplb = [UILabel new];
        _tiplb.font = [UIFont sf_systemFontOfSize:12];
        _tiplb.text = @"请调节亮度值或点击设置确认";
    }
    return _tiplb;
}

- (UIView *)sliderBGView
{
    if (!_sliderBGView) {
        _sliderBGView = [UIView new];
        _sliderBGView.backgroundColor = [UIColor whiteColor];
        
    }
    return _sliderBGView;
}

- (UILabel *)valuelb
{
    if (!_valuelb) {
        _valuelb = [UILabel new];
        _valuelb.font = [UIFont sf_systemFontOfSize:12];
        _valuelb.text = @"10%";
    }
    return _valuelb;
}

- (UILabel *)settingNameLb
{
    if (!_settingNameLb) {
        _settingNameLb = [UILabel new];
        _settingNameLb.font = [UIFont sf_systemFontOfSize:12];
        _settingNameLb.text = @"亮度";
    }
    return _settingNameLb;
}

- (BaseSlider *)slider
{
    if (!_slider) {
        _slider = [BaseSlider new];
        _slider.minimumValue = 10;
        _slider.maximumValue = 100;
        _slider.minimumTrackTintColor = kAPPThemeColor;
        [_slider setThumbImage:[UIImage imageNamed:@"button"] forState:UIControlStateNormal];
        [_slider addTarget:self action:@selector(sliderValueChanged) forControlEvents:UIControlEventTouchUpInside];
        [_slider setMinimumTrackImage:[UIImage imageNamed:@"bluue1"] forState:UIControlStateNormal];
    }
    return _slider;
}

- (UIButton *)settingBtn
{
    if (!_settingBtn) {
        _settingBtn = [UIButton new];
        [_settingBtn addTarget:self action:@selector(settingBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_settingBtn setBackgroundImage:[UIImage imageNamed:@"btnBg"] forState:UIControlStateNormal];
        [_settingBtn.titleLabel setTextColor:[UIColor whiteColor]];
        _settingBtn.layer.masksToBounds = YES;
        _settingBtn.layer.cornerRadius = CurrentDeviceSize(5);
        [_settingBtn setTitle:@"设定" forState:UIControlStateNormal];
    }
    return _settingBtn;
}
@end
