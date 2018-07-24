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
#import "LightsDataPointModel.h"
#import "AppDelegate.h"
@interface MyDeviceViewController ()<MyDeviceNoDeviceViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,GizWifiDeviceDelegate,DeviceCollectionViewCellDelegate,GizDeviceSharingDelegate>

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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:NO];
    LHWeakSelf(self)
    ActionBlock rightAction = ^(UIButton *btn){

        [weakself addDeviceDidSelected];
        LHLog(@"right");
    };
    [self.naviBar  configNavigationBarWithAttrs:@{
                                                  kCustomNaviBarTitleKey:@"我的设备",
                                                  kCustomNaviBarRightImgKey:@"tianjia",
                                                  kCustomNaviBarRightActionKey:rightAction
                                                  }];
    [self requestDevices];
    [self getShareTheInvitation];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogout) name:kUserLogoutKey object:nil];
    self.dataSource = [NSMutableArray array];
    [self initUI];
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
            // 增加设备过滤，只显示绑定过且属于捷宝的产品
            for (GizWifiDevice *devcie in devs) {
                BOOL isAPPDev = NO;

                if ([devcie.productKey isEqualToString:kProductKeys[@"六路彩灯"]]) {
                    isAPPDev = YES;
                    
                }else if ([devcie.productKey isEqualToString:kProductKeys[@"滴定泵"]]){
                    isAPPDev = YES;

                }else if ([devcie.productKey isEqualToString:kProductKeys[@"无线开关"]]){
                    isAPPDev = YES;

                }else if ([devcie.productKey isEqualToString:kProductKeys[@"造浪泵"]]){
                    isAPPDev = YES;

                }else if ([devcie.productKey isEqualToString:kProductKeys[@"水泵"]]){
                    isAPPDev = YES;

                }else{
                    
                    isAPPDev = NO;
                }
                if (devcie.isBind) {
                    isAPPDev = YES;
                }else{
                    isAPPDev = NO;
                }
            
                if (isAPPDev) {
                    [self.dataSource addObject:devcie];
                }
            }
            for (GizWifiDevice *dev in self.dataSource) {
                dev.delegate = self;
                [dev setSubscribe:dev.productKey subscribed:YES];
            }
            //用单例记录下设备数组
            SDKHELPER.deviceArray = [NSMutableArray arrayWithArray:self.dataSource];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dataSource.count !=0?(self.noDeviceView.hidden = YES):(self.noDeviceView.hidden = NO);
            [self.cv reloadData];
        });
        
    };
    [[GizWifiSDK sharedInstance] getBoundDevices:[UserHelper getCurrentUser].uid token:[UserHelper getCurrentUser].token];
}

-(void)getShareTheInvitation{
    [GizDeviceSharing setDelegate:self];
    [GizDeviceSharing getDeviceSharingInfos:[UserHelper getCurrentUser].token sharingType:GizDeviceSharingToMe deviceID:nil];
    
}



#pragma mark - userLogout
- (void)userLogout
{
    [self.dataSource removeAllObjects];
    [self.cv reloadData];
    self.noDeviceView.hidden = NO;
}

#pragma mark - navigationbar right btn action
- (void)addDeviceDidSelected
{
    [self.navigationController pushViewController:[NSClassFromString(@"MyDeviceAddViewController") new] animated:YES];
}

- (void)addBtnClicked
{
    [self.navigationController pushViewController:[NSClassFromString(@"MyDeviceAddViewController") new] animated:YES];
}

#pragma mark - collectionDelegate
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
    
    if ([cell.dataDic.productKey isEqualToString:kProductKeys[@"六路彩灯"]]) {
        if ([SDKHELPER.statusDic.allKeys containsObject:cell.dataDic.did]) {
            LightsDataPointModel *lightStatusModel = [SDKHELPER.statusDic objectForKey:cell.dataDic.did];
            [cell cellSetSelectedWithStatus:[lightStatusModel.switchNum boolValue]];
        }
        
    }else if ([cell.dataDic.productKey isEqualToString:kProductKeys[@"滴定泵"]]){
        
    }else if ([cell.dataDic.productKey isEqualToString:kProductKeys[@"无线开关"]]){
        
    }else if ([cell.dataDic.productKey isEqualToString:kProductKeys[@"造浪泵"]]){
        
    }else if ([cell.dataDic.productKey isEqualToString:kProductKeys[@"水泵"]]){
        
    }
    
   

    cell.indexPath = indexPath;
    cell.delegate = self;

    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    GizWifiDevice *dev = self.dataSource[indexPath.row];
    
    if ([dev.productKey isEqualToString:kProductKeys[@"六路彩灯"]]) {
        LightsDataPointModel *lightStatusModel = [SDKHELPER.statusDic objectForKey:dev.did];
        BOOL isSwitch = !lightStatusModel.switchNum.boolValue;
        NSNumber *switchNum = [NSNumber numberWithBool:isSwitch];
        [dev write:@{@"switch":switchNum} withSN:500];
        
    }else if ([dev.productKey isEqualToString:kProductKeys[@"滴定泵"]]){
        
    }else if ([dev.productKey isEqualToString:kProductKeys[@"无线开关"]]){
        
    }else if ([dev.productKey isEqualToString:kProductKeys[@"造浪泵"]]){
        
    }else if ([dev.productKey isEqualToString:kProductKeys[@"水泵"]]){
        
    }
}


#pragma mark - DeviceCollectionViewCellDelegate
-(void)DeviceCollectionViewCell:(DeviceCollectionViewCell *)cell longTapWithIndexPath:(NSIndexPath *)indexPath{
    //长按
    GizWifiDevice *dev = [self.dataSource objectAtIndex:indexPath.row];
    NSString *type = dev.productKey;
    if ([type isEqualToString:kProductKeys[@"六路彩灯"]]) {
        MyDeviceCaiDengTurnViewController *vc = [MyDeviceCaiDengTurnViewController new];
        vc.dev = dev;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([type isEqualToString:kProductKeys[@"滴定泵"]]){
        DianDiBengViewController *vc = [DianDiBengViewController new];
        vc.dev = dev;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([type isEqualToString:kProductKeys[@"无线开关"]]){
        MyDeviceWirelessTurnViewController *vc = [MyDeviceWirelessTurnViewController new];
        vc.dev = dev;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([type isEqualToString:kProductKeys[@"造浪泵"]]){
        ZaoLangBengViewController *vc = [ZaoLangBengViewController new];
        vc.dev = dev;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([type isEqualToString:kProductKeys[@"水泵"]]){
        ShuiBengViewController *vc = [ShuiBengViewController new];
        vc.dev = dev;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


#pragma mark - device contro delegate
- (void)device:(GizWifiDevice *)device didSetSubscribe:(NSError *)result isSubscribed:(BOOL)isSubscribed
{
    if(result.code == GIZ_SDK_SUCCESS) {
        // 订阅或取消订阅成功
        if (isSubscribed) {
            
            LHLog(@"订阅成功");
        }else{
            LHLog(@"订阅失败");
        }
    }
}

- (void)device:(GizWifiDevice *)device didReceiveData:(NSError *)result data:(NSDictionary<NSString *,id> *)dataMap withSN:(NSNumber *)sn
{
    if(result.code == GIZ_SDK_SUCCESS) {
        // 命令序号相符，开灯指令执行成功
        NSDictionary *data = dataMap[@"data"];
        if (data != nil) {
            if ([device.productKey isEqualToString:kProductKeys[@"六路彩灯"]]) {
                LightsDataPointModel *lightStatusModel = [[LightsDataPointModel alloc] initWithData:dataMap withDevice:device];
                [SDKHELPER.statusDic setObject:lightStatusModel forKey:device.did];
            
            }
            [self.cv performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
        }
    }
}

-(void)didGetDeviceSharingInfos:(NSError *)result deviceID:(NSString *)deviceID deviceSharingInfos:(NSArray<GizDeviceSharingInfo *> *)deviceSharingInfos{
    if (result.code == GIZ_SDK_SUCCESS) {
        NSInteger your_sharing_id = -1;
        GizDeviceSharingInfo *devcieShare;
        for (int i = 0; i < deviceSharingInfos.count; i++) {
            GizDeviceSharingInfo* mDeviceSharing = [deviceSharingInfos objectAtIndex:i];
            if (mDeviceSharing.status == GizDeviceSharingNotAccepted) {
                your_sharing_id = mDeviceSharing.id;
                devcieShare = mDeviceSharing;
                break;
            }
        }
        
        // 接受邀请
        if (your_sharing_id != -1) {
            
            [self alertShowMessage:[NSString stringWithFormat:@"账号：%@向您分享了一台设备?",devcieShare.userInfo.phone] title:@"提示" leftBtnText:@"取消" rightBtnText:@"接受分享" leftCallback:nil rightCallback:^{
                [GizDeviceSharing acceptDeviceSharing:[UserHelper getCurrentUser].token sharingID:your_sharing_id accept:YES];
            }];
            
        }
    } else {
        // 获取失败
        
    }
}

// 实现接受分享邀请的回调
- (void)didAcceptDeviceSharing:(NSError*)result sharingID:(NSInteger)sharingID {
    if(result.code == GIZ_SDK_SUCCESS) {
        // 接受成功
        [self requestDevices];
    } else {
        // 接受失败
    }
}

#pragma mark - lazy init
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
