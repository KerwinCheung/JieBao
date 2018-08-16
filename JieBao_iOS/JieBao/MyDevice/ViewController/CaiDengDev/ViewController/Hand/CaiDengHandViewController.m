//
//  CaiDengHandViewController.m
//  JieBao
//
//  Created by wen on 2018/4/23.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//  手动模式

#import "CaiDengHandViewController.h"
#import "SliderView.h"
#import "LightsDataPointModel.h"
@interface CaiDengHandViewController ()<GizWifiDeviceDelegate,SliderViewDelegate>

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
    

    [self.naviBar  configNavigationBarWithAttrs:@{
                                                  kCustomNaviBarLeftActionKey:leftAction,
                                                  kCustomNaviBarLeftImgKey:@"back",
                                                  kCustomNaviBarTitleKey:@"手动模式",
                                                 
                                                  }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kAPPBackGround;
    [self initUI];
    
    if (self.dev) {
        self.dev.delegate = self;
        [self.dev getDeviceStatus:@[@"color_white",@"color_blue1",@"color_blue2",@"color_green",@"color_red",@"volor_violet"]];
    }else{
        //设置分组初始状态,使用某一台设备的状态
        for (CustomDevice *customDev in self.group.devs) {
            if ([SDKHELPER.statusDic.allKeys containsObject:customDev.did]) {
                LightsDataPointModel *lightStatusModel = [SDKHELPER.statusDic objectForKey:customDev.did];
                self.whiteSlider.value = [lightStatusModel.color_whiteNum floatValue];
                self.sapphireBlueSlider.value = [lightStatusModel.color_blue1Num floatValue];
                self.blueSlider.value = [lightStatusModel.color_blue2Num floatValue];
                self.greenSlider.value = [lightStatusModel.color_greenNum floatValue];
                self.redSlider.value = [lightStatusModel.color_redNum floatValue];
                self.purpleSlider.value = [lightStatusModel.volor_violetNum floatValue];
                return;
            }
        }
    }
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
        make.width.lessThanOrEqualTo(@300);
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
- (void)setConfigWithTag:(NSInteger )tag
{
    if (self.dev) {
        switch (tag) {
            case 100:
                [self.dev write:@{@"mode":@(0),
                                  @"color_white":@(self.whiteSlider.value),
                                  @"Timer":@(0)}
                         withSN:201];
                break;
            case 101:
                [self.dev write:@{@"mode":@(0),
                                  @"color_blue1":@(self.sapphireBlueSlider.value),
                               
                                  @"Timer":@(0)}
                         withSN:201];
                break;
            case 102:
                [self.dev write:@{@"mode":@(0),
                                 
                                  @"color_blue2":@(self.blueSlider.value),
                                 
                                  @"Timer":@(0)}
                         withSN:201];
                break;
            case 103:
                [self.dev write:@{@"mode":@(0),
                                  
                                  @"color_green":@(self.greenSlider.value),
                                 
                                  @"Timer":@(0)}
                         withSN:201];
                break;
            case 104:
                [self.dev write:@{@"mode":@(0),
                                 
                                  @"color_red":@(self.redSlider.value),
                                 
                                  @"Timer":@(0)}
                         withSN:201];
                break;
            case 105:
                [self.dev write:@{@"mode":@(0),
                                
                                  @"volor_violet":@(self.purpleSlider.value),
                                  @"Timer":@(0)}
                         withSN:201];
                break;
                
            default:
                break;
        }
        

    }else{
        [self setGroupInstructionWithTag:tag];
        
//        NSDictionary *sendDataDic = @{@"mode":@(0),
//                                      @"color_white":@(self.whiteSlider.value),
//                                      @"color_blue1":@(self.sapphireBlueSlider.value),
//                                      @"color_blue2":@(self.blueSlider.value),
//                                      @"color_green":@(self.greenSlider.value),
//                                      @"color_red":@(self.redSlider.value),
//                                      @"volor_violet":@(self.purpleSlider.value),
//                                      @"Timer":@(0)};
//
//
//
//
//
//            [NetworkHelper sendRequest:sendDataDic Method:@"POST" Path:[NSString stringWithFormat:@"https://api.gizwits.com/app/group/%@/control",self.group.gid] callback:^(NSData *data, NSError *error) {
//                if (!data || error) {
//                    return ;
//                }
//
//            }];
    }
}

-(void)setGroupInstructionWithTag:(NSInteger)tag{
    
    NSDictionary *sendDataDic = [NSDictionary dictionary];
    switch (tag) {
        case 100:
           
            sendDataDic = @{@"mode":@(0),
                            @"color_white":@(self.whiteSlider.value),
                          
                            @"Timer":@NO};
            break;
        case 101:
            
            sendDataDic = @{@"mode":@(0),
                            @"color_blue1":@(self.sapphireBlueSlider.value),
                          
                            @"Timer":@NO};
            break;
        case 102:
           
            sendDataDic = @{@"mode":@(0),
                          
                            @"color_blue2":@(self.blueSlider.value),
                        
                            @"Timer":@NO};
            break;
        case 103:
          
            sendDataDic = @{@"mode":@(0),
                           
                            @"color_green":@(self.greenSlider.value),
                          
                            @"Timer":@NO};
            break;
        case 104:
          
            sendDataDic = @{@"mode":@(0),
                           
                            @"color_red":@(self.redSlider.value),
                            @"Timer":@NO};
            break;
        case 105:
          
            sendDataDic = @{@"mode":@(0),
                            @"volor_violet":@(self.purpleSlider.value),
                            @"Timer":@NO};
            break;
            
        default:
            break;
    }
    
    if (sendDataDic.count > 0) {
        
        [NetworkHelper sendRequest:sendDataDic Method:@"POST" Path:[NSString stringWithFormat:@"https://api.gizwits.com/app/group/%@/control",self.group.gid] callback:^(NSData *data, NSError *error) {
            
            if (!data || error) {
                return ;
            }
            
            NSArray *list =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            LHLog(@"返回 %@",list);
            
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
                self.whiteSlider.value = [[data objectForKey:@"color_white"] floatValue];
                self.sapphireBlueSlider.value = [[data objectForKey:@"color_blue1"] floatValue];
                self.blueSlider.value = [[data objectForKey:@"color_blue2"] floatValue];
                self.greenSlider.value = [[data objectForKey:@"color_green"] floatValue];
                self.redSlider.value = [[data objectForKey:@"color_red"] floatValue];
                self.purpleSlider.value = [[data objectForKey:@"volor_violet"] floatValue];
                
                LHLog(@"color_white=%f color_blue1=%f color_blue2 =%f color_green =%f color_red=%f volor_violet=%f ",[[data objectForKey:@"color_white"] floatValue],[[data objectForKey:@"color_blue1"] floatValue],[[data objectForKey:@"color_blue2"] floatValue],[[data objectForKey:@"color_green"] floatValue],[[data objectForKey:@"color_red"] floatValue],[[data objectForKey:@"volor_violet"] floatValue]);
            });
            return;
        }
        
        
        if (sn.integerValue == 201) {
//            [HudHelper showSuccessWithStatus:@"设置成功"];
        }
    }else{
        if ([sn integerValue] == 101) {
            [HudHelper showErrorWithStatus:@"设置失败"];
            return;
        }
    }
}



#pragma mark - SliderView Delegate
-(void)SliderViewChanged:(float)value withSliderView:(SliderView *)sliderView{
    switch (sliderView.tag) {
        case 100:
        {
            [self setConfigWithTag:100];
        }
            break;
        case 101:
        {
            [self setConfigWithTag:101];

        }
            break;
        case 102:
        {
            [self setConfigWithTag:102];

        }
            break;
        case 103:
        {
            [self setConfigWithTag:103];

        }
            break;
        case 104:
        {
            [self setConfigWithTag:104];

        }
            break;
        case 105:
        {
            [self setConfigWithTag:105];

        }
            break;
            
        default:
            break;
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
        _whiteSlider = [[SliderView alloc]init];
        [_whiteSlider setTrickImg:@"wirte"];
        _whiteSlider.title = @"白色";
        _whiteSlider.tag = 100;
        _whiteSlider.delegate = self;
    }
    return _whiteSlider;
}

- (SliderView *)sapphireBlueSlider
{
    if (!_sapphireBlueSlider) {
        _sapphireBlueSlider = [SliderView new];
        [_sapphireBlueSlider setTrickImg:@"sblue"];
        _sapphireBlueSlider.title = @"宝蓝色";
        _sapphireBlueSlider.tag = 101;
        _sapphireBlueSlider.delegate = self;
    }
    return _sapphireBlueSlider;
}

- (SliderView *)blueSlider
{
    if (!_blueSlider) {
        _blueSlider = [SliderView new];
        [_blueSlider setTrickImg:@"bluue1"];
        _blueSlider.title = @"蓝色";
        _blueSlider.tag = 102;
        _blueSlider.delegate = self;
    }
    return _blueSlider;
}

- (SliderView *)greenSlider
{
    if (!_greenSlider) {
        _greenSlider = [SliderView new];
        [_greenSlider setTrickImg:@"gree"];;
        _greenSlider.title = @"绿色";
        _greenSlider.tag = 103;
        _greenSlider.delegate = self;
    }
    return _greenSlider;
}

- (SliderView *)redSlider
{
    if (!_redSlider) {
        _redSlider = [SliderView new];
        [_redSlider setTrickImg:@"sred"];
        _redSlider.title = @"红色";
        _redSlider.tag = 104;
        _redSlider.delegate = self;
    }
    return _redSlider;
}

- (SliderView *)purpleSlider
{
    if (!_purpleSlider) {
        _purpleSlider = [SliderView new];
        [_purpleSlider setTrickImg:@"szi"];
        _purpleSlider.title = @"紫色";
        _purpleSlider.tag = 105;
        _purpleSlider.delegate = self;
    }
    return _purpleSlider;
}
@end
