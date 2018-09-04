//
//  ShuiBengViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/5/16.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "ShuiBengViewController.h"
#import "SelectionView.h"
#import "MyDeviceRenameViewController.h"
#import "MyDeviceShareViewController.h"
#import "UIViewController+Custom.h"
#import "ShuiBengWeiShiViewController.h"
#import "WDCircleAnimationView.h"
#import "WeiShiTimingViewController.h"

@interface ShuiBengViewController ()<SelectionViewDelegate>

@property (nonatomic, strong) UILabel *sublb;

@property (nonatomic, strong) UIView *progressView;

@property(strong,nonatomic) WDCircleAnimationView * circleView ;

@property (nonatomic, strong) UIButton *turnBtn;

@property (nonatomic, strong) SelectionView *weishiView;

@property (nonatomic, strong) SelectionView *timingView;

@property (nonatomic, strong) SelectionView *timingModeView;

@end

@implementation ShuiBengViewController

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
    LHWeakSelf(self)
    ActionBlock leftAction = ^(UIButton *btn){
        [weakself.navigationController popViewControllerAnimated:YES];
    };
    ActionBlock rightAction = ^(UIButton *btn){
        [weakself showMore];
    };
    NSString *title = nil;
    if (self.dev) {
        NSRange range = NSMakeRange(self.dev.macAddress.length - 6, 6);
        NSString *lastMacStr = [self.dev.macAddress substringWithRange:range];
        NSString *deaultStr = [NSString stringWithFormat:@"%@%@",[UtilHelper getDefaultNameStrPrefixWithProductKey:self.dev.productKey],lastMacStr];
        title = self.dev.alias.length==0?deaultStr:self.dev.alias;
        [self.naviBar  configNavigationBarWithAttrs:@{
                                                      kCustomNaviBarLeftActionKey:leftAction,
                                                      kCustomNaviBarLeftImgKey:@"back",
                                                      kCustomNaviBarRightImgKey:@"more",
                                                      kCustomNaviBarTitleKey:title,
                                                      kCustomNaviBarRightActionKey:rightAction
                                                      }];
    }else{
        title = self.group.group_name;
        
        [self.naviBar  configNavigationBarWithAttrs:@{
                                                      kCustomNaviBarLeftActionKey:leftAction,
                                                      kCustomNaviBarLeftImgKey:@"back",
                                                      kCustomNaviBarTitleKey:title,
                                                      }];
    }
}

- (void)initUI
{
    LHWeakSelf(self)
    [self.bgView addSubview:self.sublb];
    [self.bgView addSubview:self.progressView];
    [self.bgView addSubview:self.circleView];
    [self.bgView addSubview:self.turnBtn];
    [self.bgView addSubview:self.weishiView];
    [self.bgView addSubview:self.timingModeView];
    [self.bgView addSubview:self.timingView];
    
    [self.sublb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@(CurrentDeviceSize(20)));
        make.width.lessThanOrEqualTo(@200);
    }];
    
    [self.progressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(weakself.sublb.mas_bottom);
        make.height.equalTo(@(CurrentDeviceSize(LL_ScreenWidth-60)));
    }];
    
    [self.turnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakself.circleView);
        make.size.mas_equalTo(CGSizeMake(LL_ScreenWidth-200,LL_ScreenWidth-200));
    }];
    
    [self.weishiView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@(CurrentDeviceSize(44)));
        make.top.equalTo(weakself.progressView.mas_bottom).offset(CurrentDeviceSize(20));
    }];
    
    [self.timingModeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@(CurrentDeviceSize(44)));
        make.top.equalTo(weakself.weishiView.mas_bottom);
    }];
    
    [self.timingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@(CurrentDeviceSize(44)));
        make.top.equalTo(weakself.timingModeView.mas_bottom);
    }];
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

- (void)turnBtnClicked:(UIButton *)btn
{
    LHLog(@"open");
    btn.selected = !btn.selected;
    [self.dev write:@{@"switch":@(btn.selected)} withSN:99];
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
    [[GizWifiSDK sharedInstance] unbindDevice:[UserHelper getCurrentUser].uid token:[UserHelper getCurrentUser].token did:self.dev.did];
}

- (UILabel *)sublb
{
    if (!_sublb) {
        _sublb = [UILabel new];
        _sublb.text = @"请选择手动或定时模式";
        _sublb.font = [UIFont sf_systemFontOfSize:13];
    }
    return _sublb;
}

- (UIView *)progressView
{
    if (!_progressView) {
        _progressView = [UIView new];
    }
    return _progressView;
}

- (WDCircleAnimationView *)circleView
{
    if (!_circleView) {
        _circleView = [[WDCircleAnimationView alloc] initWithFrame:CGRectMake(CurrentDeviceSize(40) ,CurrentDeviceSize(20), CurrentDeviceSize(LL_ScreenWidth-80), CurrentDeviceSize(LL_ScreenWidth-80))];
        _circleView.text = @"初始的文字";
        _circleView.temperInter = 0 ;
    }
    return _circleView;
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


- (void)transferBtnClicked:(id)obj
{
    BaseViewController *vc = nil;
    if ([obj isEqual:self.weishiView]) {
        vc = [ShuiBengWeiShiViewController new];
        ((ShuiBengWeiShiViewController *)vc).dev = self.dev;
    }else if ([obj isEqual:self.timingModeView])
    {
        vc = [WeiShiTimingViewController new];
        ((WeiShiTimingViewController *)vc).dev = self.dev;
    }else if ([obj isEqual:self.timingView])
    {
        
    }
    
    [self.navigationController pushViewController:vc animated:YES];
}

- (SelectionView *)weishiView
{
    if (!_weishiView) {
        _weishiView = [SelectionView new];
        _weishiView.title = @"喂食";
        _weishiView.subTitle = @"关";
        _weishiView.delegate = self;
    }
    return _weishiView;
}

- (SelectionView *)timingModeView
{
    if (!_timingModeView) {
        _timingModeView = [SelectionView new];
        _timingModeView.title = @"定时模式";
        _timingModeView.subTitle = @"定时模式一";
        _timingModeView.delegate = self;
    }
    return _timingModeView;
}

- (SelectionView *)timingView
{
    if (!_timingView) {
        _timingView = [SelectionView new];
        _timingView.title = @"定时";
        _timingView.transferHidden = YES;
        _timingView.subTitle = @"开启";
        _timingView.delegate = self;
        _timingView.transferHidden = YES;
    }
    return _timingView;
}
@end
