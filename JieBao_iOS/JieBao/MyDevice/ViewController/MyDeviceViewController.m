//
//  OpenGroupViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/13.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "MyDeviceViewController.h"
#import "UIViewController+Custom.h"
#import "MyDeviceNoDeviceView.h"
#import "BaseCollectionView.h"
#import "DianDiBengViewController.h"
#import "MyDeviceCaiDengTurnViewController.h"
#import "ShuiBengViewController.h"
#import "MyDeviceWirelessTurnViewController.h"
#import "DeviceCollectionViewCell.h"
#import "ZaoLangBengViewController.h"

@interface MyDeviceViewController ()<MyDeviceNoDeviceViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,GizWifiDeviceDelegate>

@property (nonatomic, strong) BaseCollectionView *cv;

@property (nonatomic, strong) MyDeviceNoDeviceView *noDeviceView;

@property (nonatomic, strong) NSMutableArray<GizWifiDevice *> *dataSource;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) DeviceCollectionViewCell *currentCell;

@end

@implementation MyDeviceViewController

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogout) name:kUserLogoutKey object:nil];
    self.dataSource = [NSMutableArray array];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
    LHWeakSelf(self)
    ActionBlock rightAction = ^(UIButton *btn){//MyDeviceCaiDengTurnViewController DianDiBengViewController MyDeviceWirelessTurnViewController ZaoLangBengViewController
//        [weakself.navigationController pushViewController:[NSClassFromString(@"ShuiBengViewController") new] animated:YES];
    [weakself addDeviceDidSelected];
        LHLog(@"right");
    };
    
    
    [self.naviBar  configNavigationBarWithAttrs:@{
                                                  kCustomNaviBarTitleKey:@"我的设备",
                                                  kCustomNaviBarRightImgKey:@"tianjia",
                                                  kCustomNaviBarRightActionKey:rightAction
                                                  }];
    [self requestDevices];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)initUI
{
    [self.bgView addSubview:self.cv];
    [self.bgView addSubview:self.noDeviceView];

    [self.cv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@0);
    }];
    
    [self.noDeviceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@0);
    }];
}

- (void)requestDevices
{
    //获取绑定的设备
    LHWeakSelf(self)
    [SDKHelper shareInstance].discoverDeviceBlock = ^(NSArray<GizWifiDevice *> *devs) {
        [self.dataSource removeAllObjects];
        if (devs.count > 0) {
            weakself.noDeviceView.hidden = YES;
            [weakself.dataSource addObjectsFromArray:devs];
        }else
        {
            weakself.noDeviceView.hidden = NO;
        }
        [weakself.cv reloadData];
    };
    [[GizWifiSDK sharedInstance] getBoundDevices:[UserHelper getCurrentUser].uid token:[UserHelper getCurrentUser].token];
}

- (void)userLogout
{
    [self.dataSource removeAllObjects];
    [self.cv reloadData];
    self.noDeviceView.hidden = NO;
}

- (void)deviceCellGroupDidSelected:(GizWifiDevice *)model
{
    NSString *type = model.productKey;
    if ([type isEqualToString:kProductKeys[@"六路彩灯"]]) {
        MyDeviceCaiDengTurnViewController *vc = [MyDeviceCaiDengTurnViewController new];
        vc.dev = model;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([type isEqualToString:kProductKeys[@"滴定泵"]]){
        DianDiBengViewController *vc = [DianDiBengViewController new];
        vc.dev = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([type isEqualToString:kProductKeys[@"无线开关"]]){
        MyDeviceWirelessTurnViewController *vc = [MyDeviceWirelessTurnViewController new];
        vc.dev = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([type isEqualToString:kProductKeys[@"造浪泵"]]){
        ZaoLangBengViewController *vc = [ZaoLangBengViewController new];
        vc.dev = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([type isEqualToString:kProductKeys[@"水泵"]]){
        ShuiBengViewController *vc = [ShuiBengViewController new];
        vc.dev = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)addDeviceDidSelected
{
    [self.navigationController pushViewController:[NSClassFromString(@"MyDeviceAddViewController") new] animated:YES];
}

- (void)addBtnClicked
{
    [self.navigationController pushViewController:[NSClassFromString(@"MyDeviceAddViewController") new] animated:YES];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DeviceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DeviceCollectionViewCell" forIndexPath:indexPath];
    cell.dataDic = self.dataSource[indexPath.row];
    UILongPressGestureRecognizer *ges = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(tap:)];
    [cell addGestureRecognizer:ges];
    [cell addGestureRecognizer:tap];
    return cell;
}

- (void)device:(GizWifiDevice *)device didReceiveData:(NSError *)result data:(NSDictionary<NSString *,id> *)dataMap withSN:(NSNumber *)sn
{
    if(result.code == GIZ_SDK_SUCCESS) {
        // 命令序号相符，开灯指令执行成功
        if ([sn integerValue] == 500) {
            [device getDeviceStatus:@[@"switch"]];
        }else if ([sn integerValue] == 0)
        {
            NSDictionary *data = dataMap[@"data"];
            BOOL turnStatus = [data[@"switch"] boolValue];
            [self.currentCell cellSetSelectedWithStatus:turnStatus];
        }
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)ges
{
    if (ges.state == UIGestureRecognizerStateEnded) {
        [self deviceCellGroupDidSelected:((DeviceCollectionViewCell *)ges.view).dataDic];
    }
}

- (void)tap:(UITapGestureRecognizer *)ges
{
    GizWifiDevice *dev = ((DeviceCollectionViewCell *)ges.view).dataDic;
    [dev setSubscribe:dev.productKey subscribed:YES];
    self.currentCell = (DeviceCollectionViewCell *)ges.view;
    dev.delegate = self;
}

- (void)device:(GizWifiDevice *)device didSetSubscribe:(NSError *)result isSubscribed:(BOOL)isSubscribed
{
    if(result.code == GIZ_SDK_SUCCESS) {
        // 订阅或取消订阅成功
        if (isSubscribed) {
            BOOL isSwitch = [self.currentCell isSwitchOn];
            [device write:@{@"switch":@(isSwitch)} withSN:500];
            LHLog(@"订阅成功");
        }else
        {
            LHLog(@"订阅失败");
        }
    }
}

- (BaseCollectionView *)cv
{
    if (!_cv) {
        UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc] init];
        fl.itemSize = CGSizeMake(2*perWidth, 2*perWidth+CurrentDeviceSize(30));
        fl.minimumLineSpacing = CurrentDeviceSize(20);
        fl.minimumInteritemSpacing = CurrentDeviceSize(20);
        fl.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
        _cv = [[BaseCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:fl];
        [_cv registerClass:[DeviceCollectionViewCell class] forCellWithReuseIdentifier:@"DeviceCollectionViewCell"];
        _cv.backgroundColor = kAPPBackGround;
        _cv.dataSource = self;
        _cv.delegate = self;
    }
    return _cv;
}

- (MyDeviceNoDeviceView *)noDeviceView
{
    if (!_noDeviceView) {
        _noDeviceView = [MyDeviceNoDeviceView new];
        _noDeviceView.delegate = self;
        _noDeviceView.hidden = NO;
    }
    return _noDeviceView;
}
@end
