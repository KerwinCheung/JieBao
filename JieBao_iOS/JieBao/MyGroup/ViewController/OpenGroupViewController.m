//
//  OpenGroupViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/13.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//  分组详情

#import "OpenGroupViewController.h"
#import "UIViewController+Custom.h"
#import "BaseCollectionView.h"
#import "OpenGroupCollectionViewCell.h"
#import "CustomDevice.h"
#import "YYModel.h"
#import "EditGroupViewController.h"

#import "MyDeviceCaiDengTurnViewController.h"
#import "ShuiBengViewController.h"
#import "DianDiBengViewController.h"
#import "MyDeviceWirelessTurnViewController.h"
#import "ZaoLangBengViewController.h"

#import "CaiDengGroupController.h"
#import "LightsDataPointModel.h"
@interface OpenGroupViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,OpenGroupCollectionViewCellDelegate>

@property (nonatomic, strong) BaseCollectionView *cv;

@property (nonatomic, strong) UIButton *setBtn;

@property (nonatomic, strong) NSMutableArray<CustomDevice *> *dataSource;

@end

@implementation OpenGroupViewController

- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UICOLORFROMRGB(0xededed);
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
    LHWeakSelf(self)
    ActionBlock rightAction = ^(UIButton *btn){
        [weakself showEdit];
        LHLog(@"right");
    };
    
    ActionBlock leftAction = ^(UIButton *btn){
        [weakself.navigationController popViewControllerAnimated:YES];
        LHLog(@"left");
    };
    [self.naviBar  configNavigationBarWithAttrs:@{
                                                  kCustomNaviBarLeftActionKey:leftAction,
                                                  kCustomNaviBarLeftImgKey:@"back",
                                                  kCustomNaviBarTitleKey:self.group.group_name,
                                                  kCustomNaviBarRightImgKey:@"more",
                                                  kCustomNaviBarRightActionKey:rightAction
                                                  }];
    [self requestDevices];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)initUI
{
    [self.bgView addSubview:self.cv];
    [self.bgView addSubview:self.setBtn];
    
    LHWeakSelf(self)
    [self.cv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@0);
    }];
    
    [self.setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(30)));
        make.right.equalTo(weakself.view.mas_right).offset(-CurrentDeviceSize(30));
        make.height.equalTo(@(CurrentDeviceSize(40)));
        make.bottom.equalTo(weakself.view.mas_bottom).offset(-CurrentDeviceSize(200));
    }];
}

- (void)requestDevices
{
    //获取分组的设备列表
    NSString *path = [NSString stringWithFormat:@"https://api.gizwits.com/app/group/%@/devices",self.group.gid];
    NSString *method = @"GET";
    [NetworkHelper sendRequest:nil Method:method Path:path callback:^(NSData *data, NSError *error) {
        if (!data || error) {
            return;
        }
        [self.dataSource removeAllObjects];
        NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        for (NSDictionary *dic in jsonObject) {
            CustomDevice *dev = [CustomDevice yy_modelWithJSON:dic];
            [self.dataSource addObject:dev];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.cv reloadData];
        });
    }];
}

- (void)setBtnClicked
{
    // 设置
    NSString *type = self.group.product_key;
    if ([type isEqualToString:kProductKeys[@"六路彩灯"]]) {
        MyDeviceCaiDengTurnViewController *vc = [MyDeviceCaiDengTurnViewController new];
        vc.group = self.group;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([type isEqualToString:kProductKeys[@"滴定泵"]]){
        DianDiBengViewController *vc = [DianDiBengViewController new];
        vc.group = self.group;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([type isEqualToString:kProductKeys[@"无线开关"]]){
        MyDeviceWirelessTurnViewController *vc = [MyDeviceWirelessTurnViewController new];
        vc.group = self.group;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([type isEqualToString:kProductKeys[@"造浪泵"]]){
        ZaoLangBengViewController *vc = [ZaoLangBengViewController new];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if ([type isEqualToString:kProductKeys[@"水泵"]]){
        ShuiBengViewController *vc = [ShuiBengViewController new];
        vc.group = self.group;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)showEdit
{
    LHWeakSelf(self)
    ConfirmCallback editCallBack = ^(void){
        EditGroupViewController *vc = [EditGroupViewController new];
        NSMutableArray *tempArr = [NSMutableArray array];

        for (CustomDevice *dev in self.dataSource) {
        
                [tempArr addObject:dev];
            
        }
        self.group.devs = tempArr;
        vc.group = self.group;
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    ConfirmCallback deleteCallBack = ^(void){
        [self alertShowMessage:@"您确定要删除分组?" title:@"提示" confirmCallback:^{
            [HudHelper show];
            [NetworkHelper sendRequest:nil Method:@"DELETE" Path:[NSString stringWithFormat:@"https://api.gizwits.com/app/group/%@",weakself.group.gid] callback:^(NSData *data, NSError *error) {
                [HudHelper dismiss];

                if (error) {
                    return;
                }
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [SDKHELPER removeGourpFromLocalWith:weakself.group];
                    [weakself.navigationController popViewControllerAnimated:YES];
                });
            }];
        } cancelCallback:nil];
    };
    [self actionSheetShowMessage:@[@"编辑分组",@"删除分组"] confirmCallbacks:@[editCallBack,deleteCallBack] cancelCallback:nil];
}

- (void)addBtnClicked
{
    [self.navigationController pushViewController:[NSClassFromString(@"MyDeviceAddViewController") new] animated:YES];
}

#pragma mark - collection DataSource
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
    OpenGroupCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"OpenGroupCollectionViewCell" forIndexPath:indexPath];
    CustomDevice *customeDev = self.dataSource[indexPath.row];
    cell.customDev = customeDev;
    cell.delegate = self;
    cell.indexPath = indexPath;
    
    //初始化状态
    if ([customeDev.product_key isEqualToString:kProductKeys[@"六路彩灯"]]) {
        
        if ([SDKHELPER.statusDic.allKeys containsObject:customeDev.did]) {
            LightsDataPointModel *lightStatusModel = [SDKHELPER.statusDic objectForKey:customeDev.did];
            [cell setCellStatus:lightStatusModel.switchNum.boolValue];
            
        }
        
        for (GizWifiDevice *gizDev in SDKHELPER.deviceArray) {
            if ([gizDev.did isEqualToString:customeDev.did]) {
                if (gizDev.netStatus == GizDeviceOffline) {
                    [cell setCellNoConnected];
                }
            }
        }
       
        
    }else if ([customeDev.product_key isEqualToString:kProductKeys[@"滴定泵"]]){
        
    }else if ([customeDev.product_key isEqualToString:kProductKeys[@"无线开关"]]){
        
    }else if ([customeDev.product_key isEqualToString:kProductKeys[@"造浪泵"]]){
        
    }else if ([customeDev.product_key isEqualToString:kProductKeys[@"水泵"]]){
        
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomDevice *dev = self.dataSource[indexPath.row] ;
    OpenGroupCollectionViewCell *cell = (OpenGroupCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    
    if ([dev.product_key isEqualToString:kProductKeys[@"六路彩灯"]]) {
        
        if ([SDKHELPER.statusDic.allKeys containsObject:dev.did]) {
            //只有能够获取状态的设备才可控
            LightsDataPointModel *lightStatusModel = [SDKHELPER.statusDic objectForKey:dev.did];
            BOOL isSwitch = !lightStatusModel.switchNum.boolValue;
            
            NSNumber *switchNum = [NSNumber numberWithBool:isSwitch];
            [lightStatusModel.device write:@{@"switch":switchNum} withSN:500];
            [cell setCellStatus:isSwitch];
        }
 
    }else if ([dev.product_key isEqualToString:kProductKeys[@"滴定泵"]]){
        
    }else if ([dev.product_key isEqualToString:kProductKeys[@"无线开关"]]){
        
    }else if ([dev.product_key isEqualToString:kProductKeys[@"造浪泵"]]){
        
    }else if ([dev.product_key isEqualToString:kProductKeys[@"水泵"]]){
        
    }
}

#pragma mark - OpenGroupCollectionViewCell Delegate
- (void)OpenGroupCollectionViewCell:(OpenGroupCollectionViewCell *)cell longTapWithIndexPath:(NSIndexPath *)indexPath{
    //长按
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
        [_cv registerClass:[OpenGroupCollectionViewCell class] forCellWithReuseIdentifier:@"OpenGroupCollectionViewCell"];
        _cv.dataSource = self;
        _cv.delegate = self;
        _cv.backgroundColor = kAPPBackGround;
    }
    return _cv;
}

- (UIButton *)setBtn
{
    if (!_setBtn) {
        _setBtn = [UIButton new];
        [_setBtn addTarget:self action:@selector(setBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_setBtn setTitle:@"设置" forState:UIControlStateNormal];
        [_setBtn setBackgroundImage:[UIImage imageNamed:@"btnBg"] forState:UIControlStateNormal];
        [_setBtn.titleLabel setTextColor:[UIColor whiteColor]];
        _setBtn.layer.masksToBounds = YES;
        _setBtn.layer.cornerRadius = CurrentDeviceSize(5);
    }
    return _setBtn;
}

- (NSMutableArray<CustomDevice *> *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
@end
