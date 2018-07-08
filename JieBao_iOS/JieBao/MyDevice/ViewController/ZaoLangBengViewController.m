//
//  TurnViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/17.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//




#import "ZaoLangBengViewController.h"
#import "UIViewController+Custom.h"
#import "MyDeviceRenameViewController.h"
#import "CaiDengDayTypeViewController.h"
#import "CaiDengNightTypeViewController.h"
#import "CaiDengRiLuoTypeViewController.h"
#import "CaiDengRiChuTypeViewController.h"
#import "CaiDengMorningTypeViewController.h"
#import "CaiDengHandViewController.h"
#import "CaiDengTimingTypeViewController.h"
#import "MyDeviceShareViewController.h"
#import "DragImageView.h"
#import "CircleView.h"
#import "ZaoLangBengStartViewController.h"
#import "ZaoLangBengJingDianViewController.h"
#import "ZaoLangBengZhengXianViewController.h"
#import "ZaoLangBengSuiJiViewController.h"
#import "ZaoLangBengYeJianViewController.h"
#import "ZaoLangBengWeiShiViewController.h"
#import "ZaoLangBengHengLiuViewController.h"


@interface ZaoLangBengViewController ()<GizWifiDeviceDelegate,CircleViewDelegate>
{
    DragImageView *imageviewCharitiesOne;
    DragImageView *imageviewPressOne;
    DragImageView *imageviewDetailOne;
    DragImageView *imageviewCharitiesTwo;
    DragImageView *imageviewPressTwo;
    DragImageView *imageviewDetailTwo;
    UIImageView *imageviewCenterQuick;
}

@property (nonatomic, strong) UIButton *turnBtn;

@property (nonatomic, strong) UIView *btnsBGView;

@property (nonatomic, strong) UILabel *modelLb;

@property (nonatomic, strong) UIImageView *morningImgView;

@property (nonatomic, strong) UIImageView *sunUpImgView;

@property (nonatomic, strong) UIImageView *dayImgView;

@property (nonatomic, strong) UIImageView *sunDownImgView;

@property (nonatomic, strong) UIImageView *nightImgView;

@property (nonatomic, strong) UIImageView *handImgView;

@property (nonatomic, strong) UIImageView *timingImgView;

@property (nonatomic, strong) UIImageView *currentImgView;

@property (nonatomic, strong) UILabel *currentModelLb;

@property (nonatomic, strong) UIButton *appConBtn;

@property (nonatomic, strong) UILabel *msgLb;

@property (nonatomic, strong) CircleView *circleView;

@property (nonatomic, strong) NSMutableArray<DragImageView *> *arrImage;

@end

@implementation ZaoLangBengViewController

- (instancetype)init
{
    if (self = [super init]) {
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.naviBar.title = self.dev.productName;
    self.view.backgroundColor = UICOLORFROMRGB(0xf0f0f0);
    [self initUI];
    self.dev.delegate = self;
    [self.dev setSubscribe:self.dev.productKey subscribed:YES];
    [self.dev getDeviceStatus:@[@"mode",@"switch"]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
    LHWeakSelf(self)
    ActionBlock leftAction = ^(UIButton *btn){
        [weakself.navigationController popViewControllerAnimated:YES];
        LHLog(@"left");
    };
    
    ActionBlock rightAction = ^(UIButton *btn){
        [weakself showMore];
    };
    [self.naviBar  configNavigationBarWithAttrs:@{//self.dev.alias.length==0?self.dev.productName:self.dev.alias
                                                  kCustomNaviBarLeftActionKey:leftAction,
                                                  kCustomNaviBarLeftImgKey:@"back",
                                                  kCustomNaviBarTitleKey:@"造浪泵",
                                                  kCustomNaviBarRightImgKey:@"more",
                                                  kCustomNaviBarRightActionKey:rightAction
                                                  
                                                  }];
}

- (void)initUI
{
    [self.view addSubview:self.turnBtn];
    [self.view addSubview:self.btnsBGView];
    [self.btnsBGView addSubview:self.modelLb];;
    [self.btnsBGView addSubview:self.msgLb];
    
    [self.btnsBGView addSubview:self.currentImgView];
    [self.btnsBGView addSubview:self.currentModelLb];
    
    [self initDragImageView];
    [self showImage];
    
    [self makeContraints];
}

- (void)makeContraints
{
    LHWeakSelf(self)
    [self.turnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(LL_ScreenHeight/3 - CurrentDeviceSize(40),LL_ScreenHeight/3 - CurrentDeviceSize(40)));
        make.top.equalTo(@(LL_StatusBarAndNavigationBarHeight + CurrentDeviceSize(20)));
    }];
    
    [self.btnsBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.top.equalTo(weakself.turnBtn.mas_bottom).offset(CurrentDeviceSize(20));
    }];
    
    [self.modelLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.width.lessThanOrEqualTo(@200);
        make.top.equalTo(@(CurrentDeviceSize(20)));
    }];
    
    [self.currentImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakself.circleView);
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(60), CurrentDeviceSize(60)));
    }];
    
    
    [self.msgLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.bottom.equalTo(weakself.view.mas_bottom).offset(-CurrentDeviceSize(40));
        make.width.lessThanOrEqualTo(@(CurrentDeviceSize(200)));
    }];
}

- (void)initDragImageView{
    // 添加转盘上图标1
    imageviewCharitiesOne = [[DragImageView alloc] initWithFrame:CGRectMake(0, 0, ImageWidth, ImageHeight)];
    imageviewCharitiesOne.image = [UIImage imageNamed:@"yuxuan"];
    imageviewCharitiesOne.imgName = @"yuxuan";
    imageviewCharitiesOne.selectImgName = @"yuxuan1";
    // 添加转盘上图标2
    imageviewPressOne = [[DragImageView alloc] initWithFrame:CGRectMake(0, 0, ImageWidth, ImageHeight)];
    imageviewPressOne.image = [UIImage imageNamed:@"jindian"];
    imageviewPressOne.imgName = @"jindian";
    imageviewPressOne.selectImgName = @"jindian1";
    // 添加转盘上图标3
    imageviewDetailOne = [[DragImageView alloc] initWithFrame:CGRectMake(0, 0, ImageWidth, ImageHeight)];
    imageviewDetailOne.image = [UIImage imageNamed:@"duding"];
    imageviewDetailOne.imgName = @"duding";
    imageviewDetailOne.selectImgName = @"duding1";
    
    // 添加转盘上图标4
    imageviewCharitiesTwo = [[DragImageView alloc] initWithFrame:CGRectMake(0, 0, ImageWidth, ImageHeight)];
    imageviewCharitiesTwo.image = [UIImage imageNamed:@"yewan"];
    imageviewCharitiesTwo.imgName = @"yewan";
    imageviewCharitiesTwo.selectImgName = @"yewan1";
    // 添加转盘上图标5
    imageviewPressTwo = [[DragImageView alloc] initWithFrame:CGRectMake(0, 0, ImageWidth, ImageHeight)];
    imageviewPressTwo.image = [UIImage imageNamed:@"weiyu"];
    imageviewPressTwo.imgName = @"weiyu";
    imageviewPressTwo.selectImgName = @"weiyu1";
    // 添加转盘上图标6
    imageviewDetailTwo = [[DragImageView alloc] initWithFrame:CGRectMake(0, 0, ImageWidth, ImageHeight)];
    imageviewDetailTwo.image = [UIImage imageNamed:@"zhengxuan-1"];
    imageviewDetailTwo.imgName = @"zhengxuan-1";
    imageviewDetailTwo.selectImgName = @"zhenxuan1-1";
  
    // 添加转盘中心图标
    imageviewCenterQuick = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    // 图标集合
    self.arrImage = [[NSMutableArray alloc] initWithObjects:imageviewPressOne,imageviewCharitiesOne,imageviewDetailOne,imageviewDetailTwo,imageviewCharitiesTwo,imageviewPressTwo, nil];
    
    for (int i = 0; i < self.arrImage.count; i ++) {
        DragImageView *imageview = [self.arrImage objectAtIndex:i];
        imageview.userInteractionEnabled = YES;
        // 添加点击手势，点击相应图标，跳转到某一界面
        UILongPressGestureRecognizer *tap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressWithTag:)];
        [imageview addGestureRecognizer:tap];
        imageview.tag = 100 + i;
    }
}

- (void)showImage{
    self.circleView = [[CircleView alloc] initWithFrame:ScrollFrame];
    self.circleView.arrImages = self.arrImage;
    self.circleView.delegate = self;
    self.circleView.centerImgView = imageviewCenterQuick;
    [self.btnsBGView addSubview:self.circleView];
    [self.circleView loadView];
}

- (void)showMore
{
    LHWeakSelf(self)
    ConfirmCallback renameCallBack = ^(){
        [weakself rename];
    };
    
    ConfirmCallback shareDeviceCallBack = ^(){
        [weakself shareDevice];
    };
    
    ConfirmCallback openDeviceCallBack = ^(){
        [weakself openDevice];
    };
    
    [self actionSheetShowMessage:@[[NSString stringWithFormat:@"主机(%@)",self.turnBtn.selected?@"开启":@"关闭"],@"重命名",@"设备分享"] confirmCallbacks:@[openDeviceCallBack,renameCallBack,shareDeviceCallBack] cancelCallback:nil];
}

- (void)rename
{
    MyDeviceRenameViewController *vc = [MyDeviceRenameViewController new];
    vc.dev = self.dev;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)shareDevice
{
    MyDeviceShareViewController *vc = [MyDeviceShareViewController new];
    vc.dev = self.dev;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)openDevice
{
    ZaoLangBengStartViewController *vc = [ZaoLangBengStartViewController new];
    vc.dev = self.dev;
    vc.selected = self.turnBtn.selected;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)turnBtnClicked:(UIButton *)btn
{
    LHLog(@"open");
    btn.selected = !btn.selected;
    [self.dev write:@{@"switch":@(btn.selected)} withSN:99];
}

-  (void)appConBtnClicked
{
    LHLog(@"appConBtnClicked");
    [self.navigationController pushViewController:[NSClassFromString(@"MyDeviceAPControlViewController") new] animated:YES];
}

#pragma mark --CircleViewDelegate
- (void)imgSelected:(NSInteger)tag
{
    NSInteger Tag = tag - 100;
    DragImageView *imgView = self.arrImage[Tag];
    NSString *imgStr = imgView.selectImgName;
    UIImage *img = [UIImage imageNamed:imgStr];
    self.currentImgView.image = img;
    if (Tag == 0) {
        self.currentModelLb.text = @"经典造浪";
        [self.dev write:@{@"mode":@(1)} withSN:100];
    }else if(Tag == 1)
    {
        self.currentModelLb.text = @"正弦造浪";
        [self.dev write:@{@"mode":@(2)} withSN:100];
    }else if(Tag == 2)
    {
        self.currentModelLb.text = @"随机造浪";
        [self.dev write:@{@"mode":@(4)} withSN:100];
    }else if(Tag == 3)
    {
        self.currentModelLb.text = @"恒流造浪";
        [self.dev write:@{@"mode":@(3)} withSN:100];
    }else if(Tag == 4)
    {
        self.currentModelLb.text = @"夜间模式";
        [self.dev write:@{@"mode":@(5)} withSN:100];
    }else if(Tag == 5)
    {
        self.currentModelLb.text = @"喂食模式";
        [self.dev write:@{@"mode":@(0)} withSN:100];
    }
}

- (void)longPressWithTag:(UILongPressGestureRecognizer *)ges
{
    if (ges.state != UIGestureRecognizerStateEnded) {
        return;
    }
    NSInteger tempTag = ges.view.tag;
    NSInteger index = tempTag - 100;
    if (index == 0) {
        ZaoLangBengJingDianViewController *vc = [ZaoLangBengJingDianViewController new];
        vc.dev = self.dev;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(index == 1)
    {
        ZaoLangBengZhengXianViewController *vc = [ZaoLangBengZhengXianViewController new];
        vc.dev = self.dev;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(index == 2)
    {
        ZaoLangBengSuiJiViewController *vc = [ZaoLangBengSuiJiViewController new];
        vc.dev = self.dev;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(index == 3)
    {
        ZaoLangBengHengLiuViewController *vc = [ZaoLangBengHengLiuViewController new];
        vc.dev = self.dev;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(index == 4)
    {
        ZaoLangBengYeJianViewController *vc = [ZaoLangBengYeJianViewController new];
        vc.dev = self.dev;
        [self.navigationController pushViewController:vc animated:YES];
    }else if(index == 5)
    {
        ZaoLangBengWeiShiViewController *vc = [ZaoLangBengWeiShiViewController new];
        vc.dev = self.dev;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark --CircleDelegate

- (NSArray *)weakSelfColors{
    
    return @[[UIColor clearColor],[UIColor clearColor],[UIColor clearColor],[UIColor clearColor],[UIColor clearColor],[UIColor clearColor],[UIColor clearColor]];
}

- (CGSize)buttonWithSIze{
    
    return CGSizeMake(CurrentDeviceSize(40), CurrentDeviceSize(40));
}

- (void)device:(GizWifiDevice *)device didSetSubscribe:(NSError *)result isSubscribed:(BOOL)isSubscribed
{
    if(result.code == GIZ_SDK_SUCCESS) {
        // 订阅或取消订阅成功
        if (isSubscribed) {
            LHLog(@"订阅成功");
        }else
        {
            LHLog(@"订阅失败");
        }
    }
}

- (void)device:(GizWifiDevice *)device didReceiveData:(NSError *)result data:(NSDictionary<NSString *,id> *)dataMap withSN:(NSNumber *)sn
{
    LHWeakSelf(self)
    if(result.code == GIZ_SDK_SUCCESS) {
        if (sn == 0) {
            LHLog(@"属性%@",dataMap);
            NSDictionary *data = dataMap[@"data"];
            BOOL turnStatus = [data[@"switch"] boolValue];
            NSInteger modeStatus = [data[@"mode"] integerValue];
            BOOL Fault_UART = [data[@"Fault_UART"] boolValue];
            if (Fault_UART) {
                NSString *errStr = @"串口连接故障";
                [self alertShowMessage:[NSString stringWithFormat:@"设备名:%@ \n 设备Mac:%@ \n 设备故障:%@",self.dev.productName,self.dev.macAddress,errStr] title:@"故障提示" confirmBtnText:@"确定" confirmCallback:nil];
                ErrorModel *error = [ErrorModel new];
                error.deviceName = self.dev.productName;
                error.errorName = errStr;
                error.prodeuctKey = self.dev.productKey;
                NSDate * date = [NSDate date];
                NSString * dateStr = [date formattedDateWithStyle: NSDateFormatterFullStyle];
                dateStr =  [date formattedDateWithFormat:@"YYYY.MM.dd HH:mm"];
                error.time = dateStr;
                [UtilHelper setErrorList:error];
            }
            
            if (turnStatus) {
                weakself.turnBtn.selected = turnStatus;
            }
            switch (modeStatus) {
                case 0:
                {
                    weakself.currentImgView.image = [UIImage imageNamed:@"jindian1"];
                    weakself.currentModelLb.text = @"经典造浪";
                }
                    break;
                case 1:
                {
                    weakself.currentImgView.image = [UIImage imageNamed:@"yuxuan1"];
                    weakself.currentModelLb.text = @"正弦造浪";
                }
                    break;
                case 2:
                {
                    weakself.currentImgView.image = [UIImage imageNamed:@"duding1"];
                    weakself.currentModelLb.text = @"随机造浪";
                }
                    break;
                case 3:
                {
                    weakself.currentImgView.image = [UIImage imageNamed:@"zhenxuan1-1"];
                    weakself.currentModelLb.text = @"恒流造浪";
                }
                    break;
                case 4:
                {
                    weakself.currentImgView.image = [UIImage imageNamed:@"yewan1"];
                    weakself.currentModelLb.text = @"夜间模式";
                }
                    break;
                case 5:
                {
                    weakself.currentImgView.image = [UIImage imageNamed:@"weiyu1"];
                    weakself.currentModelLb.text = @"喂食模式";
                }
                    break;
                    
                default:
                    break;
            }
        }
    }
}

- (UIButton *)turnBtn
{
    if (!_turnBtn) {
        _turnBtn = [UIButton new];
        [_turnBtn addTarget:self action:@selector(turnBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _turnBtn.backgroundColor = [UIColor whiteColor];
        [_turnBtn setImage:[UIImage imageNamed:@"open"] forState:UIControlStateSelected];
        [_turnBtn setImage:[UIImage imageNamed:@"shuibeng_close"] forState:UIControlStateNormal];
    }
    return _turnBtn;
}


- (UIView *)btnsBGView
{
    if (!_btnsBGView) {
        _btnsBGView = [UIView new];
        _btnsBGView.backgroundColor = [UIColor whiteColor];
    }
    return _btnsBGView;
}

- (UILabel *)msgLb
{
    if (!_msgLb) {
        _msgLb = [UILabel new];
        _msgLb.font = [UIFont  sf_systemFontOfSize:12];
        _msgLb.text = @"提示:长按模式图标进入模式设置页";
    }
    return _msgLb;
}

- (UILabel *)modelLb
{
    if (!_modelLb) {
        _modelLb = [UILabel new];
        _modelLb.font = [UIFont  sf_systemFontOfSize:15];
        _modelLb.text = @"请选择模式";
    }
    return _modelLb;
}

- (UIImageView *)currentImgView
{
    if (!_currentImgView) {
        _currentImgView = [UIImageView new];
    }
    return _currentImgView;
}

- (UILabel *)currentModelLb
{
    if (!_currentModelLb) {
        _currentModelLb = [UILabel new];
        _currentModelLb.font = [UIFont  sf_systemFontOfSize:15];
        _currentModelLb.hidden = YES;
    }
    return _currentModelLb;
}

@end



