//
//  AddDeviceViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/14.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "AddDeviceViewController.h"
#import "BaseTableView.h"
#import "EditAddGroupCell.h"
#import "CustomDevice.h"
#import "GroupEditCell.h"
#import "UIViewController+Custom.h"
#import "GroupEditCell.h"

@interface AddDeviceViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) BaseTableView *tb;

@property (nonatomic, strong) NSMutableArray<CustomDevice *> *dataSource;

@property (nonatomic, strong) NSMutableArray<CustomDevice *> *temps;

@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic,strong) UIView *sureBgView;

@end

@implementation AddDeviceViewController

- (instancetype)init
{
    if (self = [super init]) {
        LHWeakSelf(self)
        ActionBlock leftAction = ^(UIButton *btn){
            [weakself.navigationController popViewControllerAnimated:YES];
            LHLog(@"left");
        };
        
//        ActionBlock rightAction = ^(UIButton *btn){
//            [weakself confirm];
//            LHLog(@"left");
//        };
        
        [self.naviBar  configNavigationBarWithAttrs:@{
                                                      kCustomNaviBarLeftActionKey:leftAction,
                                                      kCustomNaviBarLeftImgKey:@"back",
                                                      kCustomNaviBarTitleKey:@"添加设备",
//                                                      kCustomNaviBarRightActionKey:rightAction,
                                                      kCustomNaviBarRightImgKey:@""
                                                      }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UICOLORFROMRGB(0xededed);
    [self initUI];
    [self discoverDevice];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)initUI
{
    [self.view addSubview:self.tb];
    [self.sureBgView addSubview:self.sureBtn];
    self.tb.tableFooterView = self.sureBgView;
}

- (void)discoverDevice
{
    [NetworkHelper sendRequest:nil Method:@"GET" Path:@"https://api.gizwits.com/app/bindings" callback:^(NSData *data, NSError *error) {
        if (!data|| error) {
            return ;
        }
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (!jsonObject) {
            return;
        }
        for (NSDictionary *dic in (NSArray *)jsonObject[@"devices"]) {
            CustomDevice *cdev = [CustomDevice yy_modelWithJSON:dic];
            if (self.group.devs.count > 0) {
                for (int i = 0;i<self.group.devs.count ;i++) {
                    CustomDevice *dev = self.group.devs[i];
                    if ([cdev.did isEqualToString:dev.did]) {
                        break;
                    }
                    if (i == self.group.devs.count - 1) {
                        [self.dataSource addObject:cdev];
                    }
                }
            }else
            {
                [self.dataSource addObject:cdev];
            }
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tb reloadData];
        });
    }];
}

- (void)confirm
{
    LHWeakSelf(self)
    NSMutableArray *ids = [NSMutableArray array];
    for (CustomDevice *dev in self.temps) {
        [ids addObject:dev.did];
    }
    NSDictionary *body = @{@"dids":ids};
    [NetworkHelper sendRequest:body Method:@"POST" Path:[NSString stringWithFormat:@"https://api.gizwits.com/app/group/%@/devices",self.group.gid] callback:^(NSData *data, NSError *error) {
        if (error) {
            return ;
        }
        NSMutableArray *arr = [NSMutableArray arrayWithArray:self.group.devs];
        [arr addObjectsFromArray:self.temps];
        self.group.devs = arr;
        dispatch_async(dispatch_get_main_queue(), ^{
            [HudHelper showSuccessWithStatus:@"添加成功"];
            [self.navigationController popViewControllerAnimated:YES];

        });
    }];
}

#pragma mark - tableView Delegate|DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"EditAddGroupCell";
    GroupEditCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[GroupEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.dataDic = self.dataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CurrentDeviceSize(50);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroupEditCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected];
    if (![cell getSelected]) {
        [self.temps removeObject:self.dataSource[indexPath.row]];
    }else
    {
        [self.temps addObject:self.dataSource[indexPath.row]];
    }
}

#pragma mark - lazy init 
- (BaseTableView *)tb
{
    if (!_tb) {
        _tb = [[BaseTableView alloc] initWithFrame:CGRectMake(0, CurrentDeviceSize(40 + LL_StatusBarAndNavigationBarHeight), LL_ScreenWidth, LL_ScreenHeight) style:UITableViewStylePlain];
        _tb.backgroundColor = [UIColor clearColor];
        _tb.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tb.scrollEnabled = NO;
        _tb.dataSource = self;
        _tb.delegate = self;
        _tb.tableFooterView = [UIView new];
    }
    return _tb;
}
-(UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setBackgroundImage:[UIImage imageNamed:@"btn_590"] forState:UIControlStateNormal];
        [_sureBtn setTitle:@"确认添加" forState:UIControlStateNormal];
        [_sureBtn setTintColor:[UIColor whiteColor]];
        [_sureBtn addTarget:self action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
        _sureBtn.frame = CGRectMake((LL_ScreenWidth - 313)*0.5, 30,313,50);
    }
    return _sureBtn;
}

-(UIView *)sureBgView{
    if (!_sureBgView) {
        _sureBgView = [[UIView alloc] init];
        _sureBgView.backgroundColor = [UIColor clearColor];
        _sureBgView.frame = CGRectMake(0, 0, LL_ScreenWidth, 100);
    }
    return _sureBgView;
}

- (NSMutableArray<CustomDevice *> *)temps
{
    if (!_temps) {
        _temps = [NSMutableArray array];
    }
    return _temps;
}

- (NSMutableArray<CustomDevice *> *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end
