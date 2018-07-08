//
//  TurnViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/17.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//


typedef NS_ENUM(NSInteger, CaiDengTpye)
{
    CaiDengTypeZaoChen = 100,
    CaiDengTypeRiChu,
    CaiDengTypeRiLuo,
    CaiDengTypeDay,
    CaiDengTypeNight,
    CaiDengTypeShouDong,
    CaiDengTypeTiming
};

#import "MyDeviceCaiDengTurnViewController.h"
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

@interface MyDeviceCaiDengTurnViewController ()<GizWifiDeviceDelegate,CircleViewDelegate>
{
    DragImageView *imageviewCharitiesOne;
    DragImageView *imageviewPressOne;
    DragImageView *imageviewDetailOne;
    DragImageView *imageviewCharitiesTwo;
    DragImageView *imageviewPressTwo;
    DragImageView *imageviewDetailTwo;
    DragImageView *imageviewDetailThree;
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

@implementation MyDeviceCaiDengTurnViewController

- (instancetype)init
{
    if (self = [super init]) {
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initUI];
    if (self.dev) {
        self.dev.delegate = self;
        [self.dev setSubscribe:self.dev.productKey subscribed:YES];
        [self.dev getDeviceStatus:@[@"mode",@"switch"]];
    }
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
    NSString *title = nil;
    if (self.dev) {
        title = self.dev.alias.length==0?self.dev.productName:self.dev.alias;
    }else
    {
        title = self.group.group_name;
    }
    [self.naviBar  configNavigationBarWithAttrs:@{
                                                  kCustomNaviBarLeftActionKey:leftAction,
                                                  kCustomNaviBarLeftImgKey:@"back",
                                                  kCustomNaviBarRightImgKey:@"more",
                                                  kCustomNaviBarTitleKey:title,
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
    imageviewCharitiesOne.image = [UIImage imageNamed:@"zaocheng"];
    imageviewCharitiesOne.imgName = @"zaocheng";
    imageviewCharitiesOne.selectImgName = @"zaocheng1";
    // 添加转盘上图标2
    imageviewPressOne = [[DragImageView alloc] initWithFrame:CGRectMake(0, 0, ImageWidth, ImageHeight)];
    imageviewPressOne.image = [UIImage imageNamed:@"richu"];
    imageviewPressOne.imgName = @"richu";
    imageviewPressOne.selectImgName = @"richu1";
    // 添加转盘上图标3
    imageviewDetailOne = [[DragImageView alloc] initWithFrame:CGRectMake(0, 0, ImageWidth, ImageHeight)];
    imageviewDetailOne.image = [UIImage imageNamed:@"riluo"];
    imageviewDetailOne.imgName = @"riluo";
    imageviewDetailOne.selectImgName = @"riluo1";
    
    // 添加转盘上图标4
    imageviewCharitiesTwo = [[DragImageView alloc] initWithFrame:CGRectMake(0, 0, ImageWidth, ImageHeight)];
    imageviewCharitiesTwo.image = [UIImage imageNamed:@"sun"];
    imageviewCharitiesTwo.imgName = @"sun";
    imageviewCharitiesTwo.selectImgName = @"sun1";
    // 添加转盘上图标5
    imageviewPressTwo = [[DragImageView alloc] initWithFrame:CGRectMake(0, 0, ImageWidth, ImageHeight)];
    imageviewPressTwo.image = [UIImage imageNamed:@"yewan"];
    imageviewPressTwo.imgName = @"yewan";
    imageviewPressTwo.selectImgName = @"yewan1";
    // 添加转盘上图标6
    imageviewDetailTwo = [[DragImageView alloc] initWithFrame:CGRectMake(0, 0, ImageWidth, ImageHeight)];
    imageviewDetailTwo.image = [UIImage imageNamed:@"shoudong"];
    imageviewDetailTwo.imgName = @"shoudong";
    imageviewDetailTwo.selectImgName = @"shoudong1";
     // 添加转盘上图标7
    imageviewDetailThree = [[DragImageView alloc] initWithFrame:CGRectMake(0, 0, ImageWidth, ImageHeight)];
    imageviewDetailThree.image = [UIImage imageNamed:@"dinggshi"];
    imageviewDetailThree.imgName = @"dinggshi";
    imageviewDetailThree.selectImgName = @"dinggshi";
    // 添加转盘中心图标
    imageviewCenterQuick = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    // 图标集合
    self.arrImage = [[NSMutableArray alloc] initWithObjects:imageviewCharitiesOne, imageviewPressOne, imageviewDetailOne, imageviewCharitiesTwo, imageviewPressTwo,imageviewDetailTwo,imageviewDetailThree, nil];
    
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
    
    ConfirmCallback deleteDeviceCallBack = ^(){
        [weakself deleteDevice];
    };
    
    [self actionSheetShowMessage:@[@"重命名",@"设备分享",@"删除设备"] confirmCallbacks:@[renameCallBack,shareDeviceCallBack,deleteDeviceCallBack] cancelCallback:nil];
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

- (void)deleteDevice
{
    LHWeakSelf(self)
    [SDKHelper shareInstance].unBindDeviceBlock = ^(BOOL success) {
        if (success) {
            [self alertShowMessage:@"删除成功" title:@"提示" confirmBtnText:@"确定" confirmCallback:nil];
        }else
        {
            [self alertShowMessage:@"删除失败" title:@"提示" confirmBtnText:@"确定" confirmCallback:nil];
        }
    };
    [self alertShowMessage:@"提示" title:@"您确定要删除此设备?" leftBtnText:@"取消" rightBtnText:@"删除" leftCallback:nil rightCallback:^{
        [[GizWifiSDK sharedInstance] unbindDevice:weakself.dev.did token:[UserHelper getCurrentUser].token did:[UserHelper getCurrentUser].uid];
    }];
}

- (void)turnBtnClicked:(UIButton *)btn
{
    LHLog(@"open");
    btn.selected = !btn.selected;
    if (self.dev) {
        [self.dev write:@{@"switch":@(btn.selected)} withSN:99];
    }else
    {
        //group
        NSDictionary *body = @{@"attrs":@{@"switch":@(btn.selected)}};
        [NetworkHelper sendRequest:body Method:@"POST" Path:[NSString stringWithFormat:@"https://api.gizwits.com/app/group/%@/control",self.group.gid] callback:^(NSData *data, NSError *error) {
            if (!data || error) {
                return ;
            }
        }];
    }
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
    NSInteger mode = 0;
    if (Tag == 0) {
        self.currentModelLb.text = @"早晨模式";
        mode = 1;
    }else if(Tag == 1)
    {
        self.currentModelLb.text = @"日出模式";
         mode = 2;
    }else if(Tag == 2)
    {
        self.currentModelLb.text = @"日落模式";
        mode = 4;
    }else if(Tag == 3)
    {
        self.currentModelLb.text = @"白天模式";
        mode = 3;
    }else if(Tag == 4)
    {
        self.currentModelLb.text = @"夜晚模式";
        mode = 5;
    }else if(Tag == 5)
    {
        self.currentModelLb.text = @"手动模式";
        mode = 0;
    }else if(Tag == 6)
    {
        self.currentModelLb.text = @"定时模式";
        mode = 7;
    }
    if (self.dev) {
        [self.dev write:@{@"mode":@(mode)} withSN:100];
    }else
    {
        //group
        NSDictionary *body = @{@"attrs":@{@"mode":@(mode)}};
        [NetworkHelper sendRequest:body Method:@"POST" Path:[NSString stringWithFormat:@"https://api.gizwits.com/app/group/%@/control",self.group.gid] callback:^(NSData *data, NSError *error) {
            if (!data || error) {
                return ;
            }
        }];
    }
}

- (void)longPressWithTag:(UILongPressGestureRecognizer *)ges
{
    if (ges.state == UIGestureRecognizerStateBegan) {
        NSInteger tempTag = ges.view.tag;
        if (tempTag == CaiDengTypeZaoChen) {
            CaiDengMorningTypeViewController *morVC = [CaiDengMorningTypeViewController new];
            morVC.group = self.group;
            morVC.dev = self.dev;
            [self.navigationController pushViewController:morVC animated:YES];
        }
        else if (tempTag == CaiDengTypeRiChu){
            CaiDengRiChuTypeViewController *richuVC = [CaiDengRiChuTypeViewController new];
            richuVC.dev = self.dev;
            richuVC.group = self.group;
            [self.navigationController pushViewController:richuVC animated:YES];
        }
        else if (tempTag == CaiDengTypeRiLuo){
            CaiDengRiLuoTypeViewController *riluoVC = [CaiDengRiLuoTypeViewController new];
            riluoVC.dev = self.dev;
            riluoVC.group = self.group;
            [self.navigationController pushViewController:riluoVC animated:YES];
        }
        else if (tempTag == CaiDengTypeDay){
            CaiDengDayTypeViewController *dayVC = [CaiDengDayTypeViewController new];
            dayVC.dev = self.dev;
            dayVC.group = self.group;
            [self.navigationController pushViewController:dayVC animated:YES];
        }
        else if (tempTag == CaiDengTypeNight){
            CaiDengNightTypeViewController *nightVC = [CaiDengNightTypeViewController new];
            nightVC.dev = self.dev;
            nightVC.group = self.group;
            [self.navigationController pushViewController:nightVC animated:YES];
        }
        else if (tempTag == CaiDengTypeShouDong){
            CaiDengHandViewController *handVC = [CaiDengHandViewController new];
            handVC.dev = self.dev;
            handVC.group = self.group;
            [self.navigationController pushViewController:handVC animated:YES];
        }
        else if (tempTag == CaiDengTypeTiming){
            CaiDengTimingTypeViewController *timeVC = [CaiDengTimingTypeViewController new];
            timeVC.dev = self.dev;
            timeVC.group = self.group;
            [self.navigationController pushViewController:timeVC animated:YES];
        }
    }
//    if (ges.state != UIGestureRecognizerStateEnded) {
//        return;
//    }
}

#pragma mark --CircleDelegate

- (NSArray *)buttonImageWithItems{
    return @[@"zaocheng",@"richu",@"riluo",@"sun",@"yewan",@"shoudong",@"dinggshi"];
}

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
        if ([sn integerValue] == 0) {
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
                    weakself.currentImgView.image = [UIImage imageNamed:@"shoudong1"];
                    weakself.currentModelLb.text = @"手动模式";
                }
                    break;
                case 1:
                {
                    weakself.currentImgView.image = [UIImage imageNamed:@"zaocheng1"];
                    weakself.currentModelLb.text = @"早晨模式";
                }
                    break;
                case 2:
                {
                    weakself.currentImgView.image = [UIImage imageNamed:@"richu1"];
                    weakself.currentModelLb.text = @"日出模式";
                }
                    break;
                case 3:
                {
                    weakself.currentImgView.image = [UIImage imageNamed:@"sun1"];
                    weakself.currentModelLb.text = @"白天模式";
                }
                    break;
                case 4:
                {
                    weakself.currentImgView.image = [UIImage imageNamed:@"riluo1"];
                    weakself.currentModelLb.text = @"日落模式";
                }
                    break;
                case 5:
                {
                    weakself.currentImgView.image = [UIImage imageNamed:@"yewan1"];
                    weakself.currentModelLb.text = @"夜晚模式";
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
        _currentImgView = [[UIImageView alloc]init];
    }
    return _currentImgView;
}

- (UILabel *)currentModelLb
{
    if (!_currentModelLb) {
        _currentModelLb = [UILabel new];
        _currentModelLb.font = [UIFont  sf_systemFontOfSize:15];
        _currentModelLb.hidden = NO;
    }
    return _currentModelLb;
}

@end



