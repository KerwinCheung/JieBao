//
//  CaiDengHandViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/23.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "CaiDengHandViewController.h"
#import "SliderView.h"

@interface CaiDengHandViewController ()<GizWifiDeviceDelegate>

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *tiplb;

@property (nonatomic, strong) SliderView *whiteSlider;

@property (nonatomic, strong) SliderView *sapphireBlueSlider;

@property (nonatomic, strong) SliderView *blueSlider;

@property (nonatomic, strong) SliderView *greenSlider;

@property (nonatomic, strong) SliderView *redSlider;

@property (nonatomic, strong) SliderView *purpleSlider;

@property (nonatomic, assign) NSInteger count;



@end

@implementation CaiDengHandViewController

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
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
        [weakself setConfig];
    };
    [self.naviBar  configNavigationBarWithAttrs:@{
                                                  kCustomNaviBarLeftActionKey:leftAction,
                                                  kCustomNaviBarLeftImgKey:@"back",
                                                  kCustomNaviBarTitleKey:@"手动设置模式",
                                                  kCustomNaviBarRightImgKey:@"设定",
                                                  kCustomNaviBarRightActionKey:rightAction
                                                  }];
    if (self.dev) {
        self.dev.delegate = self;
        [self.dev getDeviceStatus:@[@"color_white",@"color_blue1",@"color_blue2",@"color_green",@"color_red",@"volor_violet"]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kAPPBackGround;
    [self initUI];
}

- (void)initUI
{
    [self.bgView addSubview:self.imgView];
    [self.bgView addSubview:self.tiplb];
    [self.bgView addSubview:self.whiteSlider];
    [self.bgView addSubview:self.sapphireBlueSlider];
    [self.bgView addSubview:self.blueSlider];
    [self.bgView addSubview:self.greenSlider];
    [self.bgView addSubview:self.redSlider];
    [self.bgView addSubview:self.purpleSlider];
    
    [self makeContraints];
}

- (void)makeContraints
{
    LHWeakSelf(self)
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(@0);
        make.height.equalTo(@(LL_ScreenHeight/5));
    }];
    
    [self.tiplb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.top.equalTo(weakself.imgView.mas_bottom).offset(CurrentDeviceSize(10));
        make.width.lessThanOrEqualTo(@200);
    }];
    
    [self.whiteSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@(CurrentDeviceSize(70)));
        make.top.equalTo(weakself.tiplb.mas_bottom).offset(CurrentDeviceSize(10));
    }];
    
    [self.sapphireBlueSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(weakself.whiteSlider.mas_height);
        make.top.equalTo(weakself.whiteSlider.mas_bottom);
    }];
    
    [self.blueSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(weakself.whiteSlider.mas_height);
        make.top.equalTo(weakself.sapphireBlueSlider.mas_bottom);
    }];
    
    [self.greenSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(weakself.whiteSlider.mas_height);
        make.top.equalTo(weakself.blueSlider.mas_bottom);
    }];
    
    [self.redSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(weakself.whiteSlider.mas_height);
        make.top.equalTo(weakself.greenSlider.mas_bottom);
    }];
    
    [self.purpleSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(weakself.whiteSlider.mas_height);
        make.top.equalTo(weakself.redSlider.mas_bottom);
    }];
    
}

#pragma mark - navigationRightBtnAction
- (void)setConfig
{
    if (self.dev) {
        [self.dev write:@{@"mode":@(0),@"color_white":@(self.whiteSlider.value)} withSN:201];
        [self.dev write:@{@"mode":@(0),@"color_blue1":@(self.sapphireBlueSlider.value)} withSN:202];
        [self.dev write:@{@"mode":@(0),@"color_blue2":@(self.blueSlider.value)} withSN:203];
        [self.dev write:@{@"mode":@(0),@"color_green":@(self.greenSlider.value)} withSN:204];
        [self.dev write:@{@"mode":@(0),@"color_red":@(self.redSlider.value)} withSN:205];
        [self.dev write:@{@"mode":@(0),@"volor_violet":@(self.purpleSlider.value)} withSN:206];
    }else{
        NSArray *arr = @[@{@"mode":@(0),@"color_white":@(self.whiteSlider.value)},
                         @{@"mode":@(0),@"color_blue1":@(self.sapphireBlueSlider.value)},
                         @{@"mode":@(0),@"color_blue2":@(self.blueSlider.value)},
                         @{@"mode":@(0),@"color_green":@(self.greenSlider.value)},
                         @{@"mode":@(0),@"color_red":@(self.redSlider.value)},
                         @{@"mode":@(0),@"volor_violet":@(self.purpleSlider.value)}];
        for (NSDictionary *dic in arr) {
            NSDictionary *body = @{@"attrs":dic};
            [NetworkHelper sendRequest:body Method:@"POST" Path:[NSString stringWithFormat:@"https://api.gizwits.com/app/group/%@/control",self.group.gid] callback:^(NSData *data, NSError *error) {
                if (!data || error) {
                    return ;
                }
                @synchronized(self)
                {
                    self.count++;
                }
                if (self.count == 6) {
                    [HudHelper showSuccessWithStatus:@"设置成功"];
                }
            }];
        }
    }
}

#pragma mark - device delegate
- (void)device:(GizWifiDevice *)device didReceiveData:(NSError *)result data:(NSDictionary<NSString *,id> *)dataMap withSN:(NSNumber *)sn
{
    if (result.code == GIZ_SDK_SUCCESS) {
        
        if (self.dev && sn == 0) {
            NSDictionary *data = dataMap[@"data"];
            self.whiteSlider.value = [[data objectForKey:@"color_white"] floatValue];
            self.sapphireBlueSlider.value = [[data objectForKey:@"color_blue1"] floatValue];
            self.blueSlider.value = [[data objectForKey:@"color_blue2"] floatValue];
            self.greenSlider.value = [[data objectForKey:@"color_green"] floatValue];
            self.redSlider.value = [[data objectForKey:@"color_red"] floatValue];
            self.purpleSlider.value = [[data objectForKey:@"volor_violet"] floatValue];
            return;
        }
        
        @synchronized(self)
        {
            self.count++;
        }
        if (self.count == 6) {
            [HudHelper showSuccessWithStatus:@"设置成功"];
            self.count = 0;
        }
    }else{
        if ([sn integerValue] == 101) {
            [HudHelper showSuccessWithStatus:@"设置失败"];
            return;
        }
        [self showErrorWithStatusWhithCode:result.code];
    }
}

#pragma mark - getter
- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [UIImageView new];
        _imgView.image = [UIImage imageNamed:@"handhead"];
    }
    return _imgView;
}

- (UILabel *)tiplb
{
    if (!_tiplb) {
        _tiplb = [UILabel new];
        _tiplb.font = [UIFont sf_systemFontOfSize:12];
        _tiplb.text = @"请调节亮度值到合适值";
    }
    return _tiplb;
}

- (SliderView *)whiteSlider
{
    if (!_whiteSlider) {
        _whiteSlider = [SliderView new];
        [_whiteSlider setTrickImg:@"wirte"];
    }
    return _whiteSlider;
}

- (SliderView *)sapphireBlueSlider
{
    if (!_sapphireBlueSlider) {
        _sapphireBlueSlider = [SliderView new];
        [_sapphireBlueSlider setTrickImg:@"bluue1"];
    }
    return _sapphireBlueSlider;
}

- (SliderView *)blueSlider
{
    if (!_blueSlider) {
        _blueSlider = [SliderView new];
        [_blueSlider setTrickImg:@"sblue"];
    }
    return _blueSlider;
}

- (SliderView *)greenSlider
{
    if (!_greenSlider) {
        _greenSlider = [SliderView new];
        [_greenSlider setTrickImg:@"gree"];;
    }
    return _greenSlider;
}

- (SliderView *)redSlider
{
    if (!_redSlider) {
        _redSlider = [SliderView new];
        [_redSlider setTrickImg:@"sred"];
    }
    return _redSlider;
}

- (SliderView *)purpleSlider
{
    if (!_purpleSlider) {
        _purpleSlider = [SliderView new];
        [_purpleSlider setTrickImg:@"szi"];
    }
    return _purpleSlider;
}
@end
