//
//  CaiDengHandViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/23.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//  手动模式

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

//- (instancetype)init
//{
//    if (self = [super init]) {
//
//    }
//    return self;
//}

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
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kAPPBackGround;
    [self initUI];
    
    if (self.dev) {
        self.dev.delegate = self;
        [self.dev getDeviceStatus:@[@"color_white",@"color_blue1",@"color_blue2",@"color_green",@"color_red",@"volor_violet"]];
    }
    [self performSelectorOnMainThread:@selector(setSliderValue) withObject:nil waitUntilDone:NO];
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
        [self.dev write:@{@"mode":@(0),
                          @"color_white":@(self.whiteSlider.value),
                          @"color_blue1":@(self.sapphireBlueSlider.value),
                          @"color_blue2":@(self.blueSlider.value),
                          @"color_green":@(self.greenSlider.value),
                          @"color_red":@(self.redSlider.value),
                          @"volor_violet":@(self.purpleSlider.value),
                          @"Timer":@(0)}
                 withSN:201];

    }else{

        NSDictionary *sendDataDic = @{@"mode":@(0),
                                      @"color_white":@(self.whiteSlider.value),
                                      @"color_blue1":@(self.sapphireBlueSlider.value),
                                      @"color_blue2":@(self.blueSlider.value),
                                      @"color_green":@(self.greenSlider.value),
                                      @"color_red":@(self.redSlider.value),
                                      @"volor_violet":@(self.purpleSlider.value),
                                      @"Timer":@(0)};
            [NetworkHelper sendRequest:sendDataDic Method:@"POST" Path:[NSString stringWithFormat:@"https://api.gizwits.com/app/group/%@/control",self.group.gid] callback:^(NSData *data, NSError *error) {
                if (!data || error) {
                    return ;
                }

                    [HudHelper showSuccessWithStatus:@"设置成功"];
            }];
    }
}

#pragma mark - device delegate
- (void)device:(GizWifiDevice *)device didReceiveData:(NSError *)result data:(NSDictionary<NSString *,id> *)dataMap withSN:(NSNumber *)sn
{
    if (result.code == GIZ_SDK_SUCCESS) {
        
        if (self.dev && sn.integerValue == 0) {
            NSDictionary *data = dataMap[@"data"];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self performSelectorOnMainThread:@selector(setSliderValue) withObject:nil waitUntilDone:NO];
                self.whiteSlider.value = [[data objectForKey:@"color_white"] floatValue];
                self.sapphireBlueSlider.value = [[data objectForKey:@"color_blue1"] floatValue];
                self.blueSlider.value = [[data objectForKey:@"color_blue2"] floatValue];
                self.greenSlider.value = [[data objectForKey:@"color_green"] floatValue];
                self.redSlider.value = [[data objectForKey:@"color_red"] floatValue];
                self.purpleSlider.value = [[data objectForKey:@"volor_violet"] floatValue];
            });
            return;
        }
        
//        @synchronized(self)
//        {
//            self.count++;
//        }
//        if (self.count == 6) {
//            [HudHelper showSuccessWithStatus:@"设置成功"];
//            self.count = 0;
//        }
        
        if (sn.integerValue == 201) {
            [HudHelper showSuccessWithStatus:@"设置成功"];
        }
    }else{
        if ([sn integerValue] == 101) {
            [HudHelper showSuccessWithStatus:@"设置失败"];
            return;
        }
        [self showErrorWithStatusWhithCode:result.code];
    }
}

- (void)setSliderValue {
    [self.whiteSlider setValue:60];
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
        _whiteSlider = [[SliderView alloc]init];
        [_whiteSlider setTrickImg:@"wirte"];
        _whiteSlider.title = @"白色";
    }
    return _whiteSlider;
}

- (SliderView *)sapphireBlueSlider
{
    if (!_sapphireBlueSlider) {
        _sapphireBlueSlider = [SliderView new];
        [_sapphireBlueSlider setTrickImg:@"bluue1"];
        _sapphireBlueSlider.title = @"宝蓝色";
    }
    return _sapphireBlueSlider;
}

- (SliderView *)blueSlider
{
    if (!_blueSlider) {
        _blueSlider = [SliderView new];
        [_blueSlider setTrickImg:@"sblue"];
        _blueSlider.title = @"蓝色";
    }
    return _blueSlider;
}

- (SliderView *)greenSlider
{
    if (!_greenSlider) {
        _greenSlider = [SliderView new];
        [_greenSlider setTrickImg:@"gree"];;
        _blueSlider.title = @"绿色";
    }
    return _greenSlider;
}

- (SliderView *)redSlider
{
    if (!_redSlider) {
        _redSlider = [SliderView new];
        [_redSlider setTrickImg:@"sred"];
        _redSlider.title = @"红色";
    }
    return _redSlider;
}

- (SliderView *)purpleSlider
{
    if (!_purpleSlider) {
        _purpleSlider = [SliderView new];
        [_purpleSlider setTrickImg:@"szi"];
        _purpleSlider.title = @"紫色";
    }
    return _purpleSlider;
}
@end
