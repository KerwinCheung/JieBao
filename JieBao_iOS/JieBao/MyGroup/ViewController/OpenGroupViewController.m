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

@interface OpenGroupViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

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
//        for (NSArray<CustomDevice *> *arr in self.dataSource) {
//            for (CustomDevice *dev in arr) {
//                [tempArr addObject:dev];
//            }
//        }
        for (CustomDevice *dev in self.dataSource) {
        
                [tempArr addObject:dev];
            
        }
        self.group.devs = tempArr;
        vc.group = self.group;
        [self.navigationController pushViewController:vc animated:YES];
    };
    
    ConfirmCallback deleteCallBack = ^(void){
        [self alertShowMessage:@"您确定要删除分组?" title:@"提示" confirmCallback:^{
            [NetworkHelper sendRequest:nil Method:@"DELETE" Path:[NSString stringWithFormat:@"https://api.gizwits.com/app/group/%@",weakself.group.gid] callback:^(NSData *data, NSError *error) {
                if (error) {
                    return;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakself.navigationController popViewControllerAnimated:YES];
                });
            }];
        } cancelCallback:nil];
    };
    [self actionSheetShowMessage:@[@"编辑分组",@"删除分组"] confirmCallbacks:@[editCallBack,deleteCallBack] cancelCallback:nil];
}

- (void)longPress:(UILongPressGestureRecognizer *)ges
{
#pragma mark -- 先取消
//    CustomDevice *dev = ((OpenGroupCollectionViewCell *)ges.view).dataDic;
//
//    GizWifiDevice *gizDev = [GizWifiDevice new];
//    [gizDev setValue:dev.did forKey:@"did"];
//    [gizDev setValue:dev.product_key forKey:@"productKey"];
//    [gizDev setValue:dev.dev_alias forKey:@"alias"];
//    [gizDev setValue:dev.remark forKey:@"remark"];
//    if (ges.state == UIGestureRecognizerStateEnded) {
//        if ([dev.product_key isEqualToString:kProductKeys[@"六路彩灯"]]) {
//            MyDeviceCaiDengTurnViewController *vc = [MyDeviceCaiDengTurnViewController new];
//            vc.dev = gizDev;
//        }
//        else if ([dev.product_key isEqualToString:kProductKeys[@"滴定泵"]]){
//            DianDiBengViewController *vc = [DianDiBengViewController new];
//            vc.dev = gizDev;
//        }
//        else if ([dev.product_key isEqualToString:kProductKeys[@"无线开关"]]){
//            MyDeviceWirelessTurnViewController *vc = [MyDeviceWirelessTurnViewController new];
//            vc.dev = gizDev;
//        }
//        else if ([dev.product_key isEqualToString:kProductKeys[@"造浪泵"]]){
//            ZaoLangBengViewController *vc = [ZaoLangBengViewController new];
//            vc.dev = gizDev;
//        }
//        else if ([dev.product_key isEqualToString:kProductKeys[@"水泵"]]){
//            ShuiBengViewController *vc = [ShuiBengViewController new];
//            vc.dev = gizDev;
//        }
//    }
}

- (void)tap:(UITapGestureRecognizer *)ges
{
    CustomDevice *dev = ((OpenGroupCollectionViewCell *)ges.view).dataDic;
    [(OpenGroupCollectionViewCell *)ges.view cellSetSelected];
    BOOL isSwitch = [(OpenGroupCollectionViewCell *)ges.view isSwitchOn];
    NSDictionary *body = @{@"attrs":@{@"switch":@(isSwitch)}};
    [NetworkHelper sendRequest:body Method:@"POST" Path:[NSString stringWithFormat:@"https://api.gizwits.com/app/control/%@",dev.did] callback:^(NSData *data, NSError *error) {
        if (!data || error) {
            return ;
        }
    }];
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
    cell.dataDic = self.dataSource[indexPath.row];
    UILongPressGestureRecognizer *ges = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(tap:)];
    [cell addGestureRecognizer:ges];
    [cell addGestureRecognizer:tap];
    return cell;
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
