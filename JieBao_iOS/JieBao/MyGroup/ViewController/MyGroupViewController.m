//
//  MyGroupViewController.m
//  JieBao
//
//  Created by wen on 2018/4/12.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//  分组列表

#import "MyGroupViewController.h"
#import "BaseCollectionView.h"
#import "NoGroupView.h"
#import "CustomDeviceGroup.h"
#import "YYModel.h"
#import "OpenGroupViewController.h"
#import "GroupCollectionViewCell.h"
#import "LightsDataPointModel.h"
#import "LWHttpRequest.h"
@interface MyGroupViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,NoGroupViewDelegate,GroupCollectionViewCellCellDelegate>

@property (nonatomic, strong) BaseCollectionView *cv;

@property (nonatomic, strong) NoGroupView *noGroupView;

@property (nonatomic, strong) NSMutableArray<CustomDeviceGroup *> *dataSource;

@end

@implementation MyGroupViewController

- (instancetype)init
{
    if (self = [super init]) {
        
        
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UICOLORFROMRGB(0xededed);
    
    [self.bgView addSubview:self.cv];
    [self.bgView addSubview:self.noGroupView];
    
    [self.cv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@0);
    }];
    
    [self.noGroupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@0);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    LHWeakSelf(self)
    ActionBlock rightAction = ^(UIButton *btn){
        [weakself addGroupDidSelected];
        LHLog(@"right");
    };
    [self.naviBar  configNavigationBarWithAttrs:@{
                                                  kCustomNaviBarTitleKey:@"我的分组",
                                                  kCustomNaviBarRightImgKey:@"tianjia",
                                                  kCustomNaviBarRightActionKey:rightAction
                                                  }];
    [self.tabBarController.tabBar setHidden:NO];
    [self getGroupList];

}

#pragma mark - 获取分组列表
-(void)getGroupList{
    [LWHttpRequest getGroupListDidLoadData:^(NSArray *result, NSError *err) {
        if (!err) {
            SDKHELPER.groupsArray = [NSMutableArray arrayWithArray:result];
            dispatch_group_t dispatchGroup = dispatch_group_create();
            //获取队列
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            //添加并发任务
            for (CustomDeviceGroup *group in result) {
                if ([group isKindOfClass:[CustomDeviceGroup class]]) {
                    //获取分组详情
                    dispatch_group_async(dispatchGroup, queue, ^{
                        [LWHttpRequest getGroupDetailsWithGroup:group didLoadData:^(id result, NSError *err) {
                            if (err) {
                                NSLog(@"获取分组详情失败 分组id:%@",group.gid);
                            }else{
                                [SDKHELPER addGroupToLocalWith:group];
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    [self.dataSource removeAllObjects];
                                    self.dataSource = [NSMutableArray arrayWithArray:SDKHELPER.groupsArray];
                                    [self.cv reloadData];
                                    self.dataSource.count !=0?(self.noGroupView.hidden = YES):(self.noGroupView.hidden = NO);
                                });
                            }
                        }];
                    });
                }
            }
            
            //任务执行完毕后，获取通知
            dispatch_group_notify(dispatchGroup, queue, ^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.dataSource removeAllObjects];
                    self.dataSource = [NSMutableArray arrayWithArray:SDKHELPER.groupsArray];
                    [self.cv reloadData];
                    self.dataSource.count !=0?(self.noGroupView.hidden = YES):(self.noGroupView.hidden = NO);
                });
            });
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.dataSource removeAllObjects];
                self.dataSource = [NSMutableArray arrayWithArray:SDKHELPER.groupsArray];
                [self.cv reloadData];
                self.dataSource.count !=0?(self.noGroupView.hidden = YES):(self.noGroupView.hidden = NO);
            });
        }
    }];
}


#pragma mark - method
-(BOOL)checkGroupStatusWithGroup:(CustomDeviceGroup *)group{
    BOOL isStatus = NO;
    NSInteger check = 0;
    for (CustomDevice *customDev in group.devs) {
        
        if ([group.product_key isEqualToString:kProductKeys[@"六路彩灯"]]) {
            LightsDataPointModel *lightStatusModel = [SDKHELPER.statusDic objectForKey:customDev.did];
            if (lightStatusModel.switchNum.boolValue) {
                check++;
            }
            
        }else if ([group.product_key isEqualToString:kProductKeys[@"滴定泵"]]){
            
        }else if ([group.product_key isEqualToString:kProductKeys[@"无线开关"]]){
            
        }else if ([group.product_key isEqualToString:kProductKeys[@"造浪泵"]]){
            
        }else if ([group.product_key isEqualToString:kProductKeys[@"水泵"]]){
            
        }
    }
    NSInteger checkStandard = 1;
    if (group.devs.count >1) {
        checkStandard =  group.devs.count/2;
    }
    
    if (check >= checkStandard) {
        isStatus = YES;
    }
    
    return isStatus;
}

#pragma mark - collection Delegate|DataSource
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
    GroupCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"GroupCollectionViewCell" forIndexPath:indexPath];
    CustomDeviceGroup *group = self.dataSource[indexPath.row];
    cell.group = group;
    cell.delegate = self;
    cell.indexPath = indexPath;
    BOOL isSwitch = [self checkGroupStatusWithGroup:group];
    [cell setCellStatus:isSwitch];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CustomDeviceGroup *group = [self.dataSource objectAtIndex:indexPath.row];
    GroupCollectionViewCell *cell = (GroupCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [cell cellSetSelected];
    BOOL isSwitch = [cell isSwitchOn];
    
    NSString *path = [NSString stringWithFormat:@"https://api.gizwits.com/app/group/%@/control",group.gid];
    NSString *method = @"POST";
    NSDictionary *body = @{@"attrs":@{@"switch":@(isSwitch)}};
    [NetworkHelper sendRequest:body Method:method Path:path callback:^(NSData *data, NSError *error) {
        if (!data || error) {
            LHLog(@"分组控制失败");
            return;
        }
        NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    }];
}


#pragma mark - GroupCollectionViewCellCell Delegate
- (void)GroupCollectionViewCellCell:(GroupCollectionViewCell *)cell longTapWithIndexPath:(NSIndexPath *)indexPath{
    
    //长按
    CustomDeviceGroup *group = [self.dataSource objectAtIndex:indexPath.row];
    OpenGroupViewController *vc = [OpenGroupViewController new];
    vc.group = group;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)addGroupDidSelected
{
    [self.navigationController pushViewController:[NSClassFromString(@"AddGroupViewController") new] animated:YES];
}

#pragma mark - NoGroupView Delegate
-(void)addBtnClicked{
    // 添加分组
    [self addGroupDidSelected];
}


#pragma mark - lazy init
- (BaseCollectionView *)cv
{
    if (!_cv) {
        UICollectionViewFlowLayout *fl = [[UICollectionViewFlowLayout alloc] init];
        fl.itemSize = CGSizeMake(4*perWidth, 2*perWidth+CurrentDeviceSize(30));
        fl.minimumLineSpacing = CurrentDeviceSize(20);
        fl.minimumInteritemSpacing = CurrentDeviceSize(20);
        fl.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
        _cv = [[BaseCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:fl];
        [_cv registerClass:[GroupCollectionViewCell class] forCellWithReuseIdentifier:@"GroupCollectionViewCell"];
        _cv.dataSource = self;
        _cv.delegate = self;
        _cv.backgroundColor = kAPPBackGround;
    }
    return _cv;
}

- (NoGroupView *)noGroupView
{
    if (!_noGroupView) {
        _noGroupView = [NoGroupView new];
        _noGroupView.delegate = self;
    }
    return _noGroupView;
}

-(NSMutableArray<CustomDeviceGroup *> *)dataSource{
        if (!_dataSource) {
            _dataSource = [NSMutableArray array];
        }
        return _dataSource;
}


@end
