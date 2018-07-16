//
//  MyGroupViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/12.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//  分组列表

#import "MyGroupViewController.h"
#import "BaseCollectionView.h"
#import "NoGroupView.h"
#import "CustomDeviceGroup.h"
#import "YYModel.h"
#import "OpenGroupViewController.h"
#import "GroupCollectionViewCell.h"

@interface MyGroupViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,NoGroupViewDelegate>

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
    [self requestGroups];
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

}

#pragma mark - 获取分组列表
- (void)requestGroups
{
    NSString *path = @"https://api.gizwits.com/app/group";
    NSString *method = @"GET";
    [NetworkHelper sendRequest:nil Method:method Path:path callback:^(NSData *data, NSError *error) {
        if (!data || error) {
            return;
        }
        NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (!jsonObject || ![jsonObject isKindOfClass:[NSArray class]]) {
            return;
        }
        [self.dataSource removeAllObjects];
        for (NSDictionary *dic in jsonObject) {
            CustomDeviceGroup *group = [CustomDeviceGroup yy_modelWithJSON:dic];
            [self.dataSource addObject:group];
        }
       
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.cv reloadData];
            self.noGroupView.hidden = self.dataSource.count != 0;
        });
    }];
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
    cell.dataDic = self.dataSource[indexPath.row];
    UILongPressGestureRecognizer *ges = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(tap:)];
    [cell addGestureRecognizer:ges];
    [cell addGestureRecognizer:tap];
    return cell;
}

#pragma mark - 手势
- (void)longPress:(UILongPressGestureRecognizer *)ges
{
    if (ges.state == UIGestureRecognizerStateEnded) {
        CustomDeviceGroup *group = ((GroupCollectionViewCell *)ges.view).dataDic;
        OpenGroupViewController *vc = [OpenGroupViewController new];
        vc.group = group;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)tap:(UITapGestureRecognizer *)ges
{
    CustomDeviceGroup *group = ((GroupCollectionViewCell *)ges.view).dataDic;
    [(GroupCollectionViewCell *)ges.view cellSetSelected];
    BOOL isSwitch = [(GroupCollectionViewCell *)ges.view isSwitchOn];
    
    NSString *path = [NSString stringWithFormat:@"https://api.gizwits.com/app/group/%@/control",group.gid];
    NSString *method = @"POST";
    NSDictionary *body = @{@"attrs":@{@"switch":@(isSwitch)}};
    [NetworkHelper sendRequest:body Method:method Path:path callback:^(NSData *data, NSError *error) {
        if (!data || error) {
            return;
        }
        NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    }];
}

- (void)addGroupDidSelected
{
    [self.navigationController pushViewController:[NSClassFromString(@"AddGroupViewController") new] animated:YES];
}

#pragma mark - NoGroupView Delegate
-(void)addBtnClicked{
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

- (NSMutableArray<NSArray<CustomDeviceGroup *> *> *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
@end
