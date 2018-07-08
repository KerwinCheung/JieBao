//
//  DianDiBengViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/23.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "DianDiBengViewController.h"
#import "UIViewController+Custom.h"
#import "ChannelRoundView.h"
#import "ChannelView.h"
#import "MyDeviceRenameViewController.h"
#import "BuYangYeJiaoZhunViewController.h"
#import "MyDeviceShareViewController.h"
#import "ChannelSettingViewController.h"

@interface DianDiBengViewController ()<ChannelViewDelegate,GizWifiDeviceDelegate>

@property (nonatomic, strong) UIScrollView *scrView;

@property (nonatomic, strong) UIView *container;

@property (nonatomic, strong) UIButton *turnBtn;

@property (nonatomic, strong) UIView *channelBGView;

@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, strong) UILabel *msgLb;

@property (nonatomic, strong) ChannelRoundView *crView;

@property (nonatomic, strong) ChannelView *channel1;

@property (nonatomic, strong) ChannelView *channel2;

@property (nonatomic, strong) ChannelView *channel3;

@property (nonatomic, strong) ChannelView *channel4;

@property (nonatomic, assign) NSInteger channelCount;

@property (nonatomic, strong) NSMutableArray<ChannelView *> *channelViews;

@property (nonatomic, strong) NSMutableDictionary *channelStatus;

@property (nonatomic, strong) NSNumber *time;

@end

@implementation DianDiBengViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.channelCount = 4;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UICOLORFROMRGB(0xededed);
    [self.channelViews addObject:self.channel1];
    [self.channelViews addObject:self.channel2];
    [self.channelViews addObject:self.channel3];
    [self.channelViews addObject:self.channel4];
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
    [self.naviBar  configNavigationBarWithAttrs:@{
                                                  kCustomNaviBarLeftActionKey:leftAction,
                                                  kCustomNaviBarLeftImgKey:@"back",
                                                  kCustomNaviBarTitleKey:@"点滴泵01",
                                                  kCustomNaviBarRightImgKey:@"more",
                                                  kCustomNaviBarRightActionKey:rightAction
                                                  }];
}

- (void)initUI
{
    [self.bgView addSubview:self.turnBtn];
    [self.bgView addSubview:self.scrView];
    [self.bgView addSubview:self.addBtn];
    [self.scrView addSubview:self.crView];
    [self.scrView addSubview:self.channel1];
    [self.scrView addSubview:self.channel2];
    [self.scrView addSubview:self.channel3];
    [self.scrView addSubview:self.channel4];
    [self.bgView addSubview:self.msgLb];
}

- (void)makeContraints
{
    LHWeakSelf(self)

    [self.turnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(LL_ScreenHeight/3 - CurrentDeviceSize(40),LL_ScreenHeight/3 - CurrentDeviceSize(40)));
        make.top.equalTo(@(CurrentDeviceSize(20)));
    }];
    
    [self.channelBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.top.equalTo(weakself.turnBtn.mas_bottom).offset(CurrentDeviceSize(20));
    }];
    
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(CurrentDeviceSize(20)));
        make.right.equalTo(weakself.view.mas_right).offset(-CurrentDeviceSize(20));
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(30), CurrentDeviceSize(30)));
    }];
    
    [self.crView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.top.equalTo(weakself.addBtn.mas_top);
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(80), 4*CurrentDeviceSize(80)));
    }];
    
    [self.msgLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.width.lessThanOrEqualTo(@200);
        make.bottom.equalTo(weakself.view.mas_bottom).offset(-(LL_TabbarSafeBottomMargin + CurrentDeviceSize(20)));
    }];
}


- (void)showMore
{
    LHWeakSelf(self)
    ConfirmCallback buYangYeJiaoZhunCallBack = ^(){
        [weakself buYangYeJiaoZhun];
    };
    
    ConfirmCallback renameCallBack = ^(){
        [weakself rename];
    };
    
    ConfirmCallback shareDeviceCallBack = ^(){
        [weakself shareDevice];
    };
    
    ConfirmCallback deleteDeviceCallBack = ^(){
        [weakself deleteDevice];
    };
    
    [self actionSheetShowMessage:@[@"补养液校准",@"重命名",@"设备分享",@"删除设备"] confirmCallbacks:@[buYangYeJiaoZhunCallBack,renameCallBack,shareDeviceCallBack,deleteDeviceCallBack] cancelCallback:nil];
}

- (void)channelView:(id)view channelDoActionStatusType:(ChannelStatusType)type
{
    ChannelView *cview = (ChannelView *)view;
    switch (type) {
        case ChannelStatusTiming:
        {
            ChannelSettingViewController *vc = [ChannelSettingViewController new];
            vc.dev = self.dev;
            vc.title = cview.channe;
            [self.navigationController pushViewController:vc animated:YES];
            
        }
            break;
        case ChannelStatusShoudong:
            
            break;
        case ChannelStatusOff:
        
            break;
            
        default:
            break;
    }
}

- (void)buYangYeJiaoZhun
{
    BuYangYeJiaoZhunViewController *vc = [BuYangYeJiaoZhunViewController new];
    vc.dev = self.dev;
    vc.time = self.time;
    [self.navigationController pushViewController:vc animated:YES];
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
            LHLog(@"删除成功");
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
    [self.dev write:@{@"switch":@(btn.selected)} withSN:99];
}

- (void)addBtnClicked
{
    [self addChannelViewWithStatus:3];
    
}

- (void)addChannelViewWithStatus:(NSInteger)status
{
    if (self.channelCount < 8) {
        self.channelCount ++;
        self.crView.frame = CGRectMake(self.crView.frame.origin.x, self.crView.frame.origin.y, self.crView.frame.size.width, self.crView.frame.size.height + self.crView.frame.size.width);
        ChannelView *view = [[ChannelView alloc] initWithFrame:CGRectMake(self.channelCount%2==0?LL_ScreenWidth/2 - CurrentDeviceSize(60) + CurrentDeviceSize(10):(LL_ScreenWidth - CurrentDeviceSize(40))/2 + CurrentDeviceSize(10), CurrentDeviceSize(20) + (self.channelCount -1)*CurrentDeviceSize(80) + CurrentDeviceSize(10), CurrentDeviceSize(100), CurrentDeviceSize(60)) channelName:[NSString stringWithFormat:@"通道%ld",self.channelCount] Type:self.channelCount%2==0?ChannelLeft:ChannelRight];
        [view setStatus:0];
        view.channe = [NSString stringWithFormat:@"%ld",self.channelCount];
        [self.scrView addSubview:view];
        [self.channelViews addObject:view];
        [self.crView setNeedsDisplay];
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
            NSNumber *time = data[@"time1"];//校准时间
            self.time = time;
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
            
            NSArray *channels = @[@"channe1",@"channe2",@"channe3",@"channe4",@"channe5",@"channe6",@"channe7",@"channe8"];
            for (int i = 0; i < channels.count; i++) {
                [self.channelStatus setObject:data[channels[i]] forKey:channels[i]];
            }
            
            for (int i = 4; i<channels.count; i++) {
                if (self.channelStatus[channels[i]]) {
                    [self addChannelViewWithStatus:[data[channels[i]] integerValue]];
                }
            }
        }
    }
}

- (UIButton *)turnBtn
{
    if (!_turnBtn) {
        _turnBtn = [[UIButton alloc] initWithFrame:CGRectMake((LL_ScreenWidth -(LL_ScreenHeight/3 - CurrentDeviceSize(40)))/2 , CurrentDeviceSize(20), LL_ScreenHeight/3 - CurrentDeviceSize(40),LL_ScreenHeight/3 - CurrentDeviceSize(40))];
        [_turnBtn addTarget:self action:@selector(turnBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        _turnBtn.backgroundColor = UICOLORFROMRGB(0xf0f0f0);
        [_turnBtn setImage:[UIImage imageNamed:@"open"] forState:UIControlStateSelected];
        [_turnBtn setImage:[UIImage imageNamed:@"shuibeng_close"] forState:UIControlStateNormal];
    }
    return _turnBtn;
}

- (UIScrollView *)scrView
{
    if (!_scrView) {
        _scrView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.turnBtn.frame.origin.y + LL_ScreenHeight/3 - CurrentDeviceSize(40) + CurrentDeviceSize(20), LL_ScreenWidth, LL_ScreenHeight - LL_TabbarHeight - LL_StatusBarAndNavigationBarHeight)];
        _scrView.scrollEnabled = YES;
        _scrView.userInteractionEnabled = YES;
        _scrView.backgroundColor = [UIColor whiteColor];
        [_scrView setContentSize:CGSizeMake(LL_ScreenWidth, 1000)];
        [_scrView setContentOffset:CGPointMake(0, 0)];
    }
    return _scrView;
}

- (UIButton *)addBtn
{
    if (!_addBtn) {
        _addBtn = [[UIButton alloc] initWithFrame:CGRectMake(LL_ScreenWidth - CurrentDeviceSize(20) - CurrentDeviceSize(30),self.scrView.frame.origin.y + CurrentDeviceSize(20), CurrentDeviceSize(30), CurrentDeviceSize(30))];
        [_addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_addBtn setImage:[UIImage imageNamed:@"tianjia"] forState:UIControlStateNormal];
    }
    return _addBtn;
}

- (UILabel *)msgLb
{
    if (!_msgLb) {
        _msgLb = [[UILabel alloc] initWithFrame:CGRectMake((LL_ScreenWidth - 200)/2, LL_ScreenHeight - LL_StatusBarAndNavigationBarHeight - CurrentDeviceSize(30), 200, CurrentDeviceSize(30))];
        _msgLb.font = [UIFont  sf_systemFontOfSize:12];
        _msgLb.textAlignment = NSTextAlignmentCenter;
        _msgLb.text = @"提示:长按通道进入设置页";
    }
    return _msgLb;
}

- (ChannelRoundView *)crView
{
    if (!_crView) {
        _crView = [[ChannelRoundView alloc] initWithFrame:CGRectMake((LL_ScreenWidth - CurrentDeviceSize(40))/2, CurrentDeviceSize(20), CurrentDeviceSize(80), 4*CurrentDeviceSize(80))];
    }
    return _crView;
}

- (ChannelView *)channel1
{
    if (!_channel1) {
        _channel1 = [[ChannelView alloc] initWithFrame:CGRectMake((LL_ScreenWidth - CurrentDeviceSize(40))/2 + CurrentDeviceSize(10), CurrentDeviceSize(20) + CurrentDeviceSize(10), CurrentDeviceSize(100), CurrentDeviceSize(60)) channelName:@"通道1" Type:ChannelRight];
        [_channel1 setStatus:ChannelStatusOff];
        _channel1.channe = @"channe1";
        _channel1.delegate = self;
    }
    return _channel1;
}

- (ChannelView *)channel2
{
    if (!_channel2) {
        _channel2 = [[ChannelView alloc] initWithFrame:CGRectMake(LL_ScreenWidth/2 - CurrentDeviceSize(60) + CurrentDeviceSize(10), CurrentDeviceSize(20) + CurrentDeviceSize(80) + CurrentDeviceSize(10), CurrentDeviceSize(100), CurrentDeviceSize(60)) channelName:@"通道2" Type:ChannelLeft];
         [_channel2 setStatus:ChannelStatusShoudong];
        _channel2.channe = @"channe2";
        _channel2.delegate = self;
    }
    return _channel2;
}

- (ChannelView *)channel3
{
    if (!_channel3) {
        _channel3 = [[ChannelView alloc] initWithFrame:CGRectMake((LL_ScreenWidth - CurrentDeviceSize(40))/2  + CurrentDeviceSize(10), CurrentDeviceSize(20) + 2*CurrentDeviceSize(80) + CurrentDeviceSize(10), CurrentDeviceSize(100), CurrentDeviceSize(60)) channelName:@"通道2" Type:ChannelRight];
         [_channel3 setStatus:ChannelStatusTiming];
        _channel3.channe = @"channe3";
        _channel3.delegate = self;
    }
    return _channel3;
}

- (ChannelView *)channel4
{
    if (!_channel4) {
        _channel4 = [[ChannelView alloc] initWithFrame:CGRectMake(LL_ScreenWidth/2 - CurrentDeviceSize(60) + CurrentDeviceSize(10), CurrentDeviceSize(20) + 3*CurrentDeviceSize(80) + CurrentDeviceSize(10), CurrentDeviceSize(100), CurrentDeviceSize(60)) channelName:@"通道2" Type:ChannelLeft];
        _channel4.channe = @"channe4";
        _channel4.delegate = self;
    }
    return _channel4;
}

- (NSMutableDictionary *)channelStatus
{
    if (!_channelStatus) {
        _channelStatus = [NSMutableDictionary dictionary];
    }
    return _channelStatus;
}

- (NSMutableArray<ChannelView *> *)channelViews
{
    if (!_channelViews) {
        _channelViews = [NSMutableArray array];
    }
    return _channelViews;
}
@end
