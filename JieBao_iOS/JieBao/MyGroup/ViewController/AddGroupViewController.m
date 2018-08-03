//
//  AddGroupViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/14.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "AddGroupViewController.h"
#import "BaseTableView.h"
#import "AddGroupCell.h"

@interface AddGroupViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) BaseTableView *tb;

@property (nonatomic, strong) UILabel *subLb;

@property (nonatomic, strong) NSArray<DeviceModel *> *dataSource;

@end

@implementation AddGroupViewController

- (instancetype)init
{
    if (self = [super init]) {
        DeviceModel *zaolangBeng = [DeviceModel new];
        zaolangBeng.type = DeviceTpyeZaoLangBeng;
        zaolangBeng.deviceName = @"造浪泵";
        DeviceModel *diandiBeng = [DeviceModel new];
        diandiBeng.type = DeviceTpyeDianDiBeng;
        diandiBeng.deviceName = @"滴定泵";
        DeviceModel *shuiBeng = [DeviceModel new];
        shuiBeng.type = DeviceTpyeShuiBeng;
        shuiBeng.deviceName = @"水泵";
        DeviceModel *wuxianKaiguan = [DeviceModel new];
        wuxianKaiguan.type = DeviceTpyeKaiGuan;
        wuxianKaiguan.deviceName = @"无线开关";
        DeviceModel *caideng = [DeviceModel new];
        caideng.type = DeviceTpyeCaiDeng;
        caideng.deviceName = @"六路彩灯";
        self.dataSource = @[caideng];
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UICOLORFROMRGB(0xededed);
    [self initUI];
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
    [self.naviBar  configNavigationBarWithAttrs:@{
                                                  kCustomNaviBarLeftActionKey:leftAction,
                                                  kCustomNaviBarLeftImgKey:@"back",
                                                  kCustomNaviBarTitleKey:@"添加分组",
                                                  }];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)initUI
{
    [self.bgView addSubview:self.subLb];
    [self.bgView addSubview:self.tb];
    
    LHWeakSelf(self)
    [self.subLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.top.equalTo(@(CurrentDeviceSize(20)));
        make.width.lessThanOrEqualTo(@300);
    }];
    
    [self.tb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(weakself.subLb.mas_bottom).offset(CurrentDeviceSize(5));
        make.height.equalTo(@(5*CurrentDeviceSize(44)));
    }];
}


#pragma mark - tableView Delegate|DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"AddGroupCell";
    AddGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[AddGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
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
    return CurrentDeviceSize(44);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [UserHelper shareInstance].productSecretKey = kProductKeys[self.dataSource[indexPath.row].deviceName];
    [self.navigationController pushViewController:[NSClassFromString(@"EditAddGroupViewController") new] animated:YES];
}

#pragma mark - lazy init
- (BaseTableView *)tb
{
    if (!_tb) {
        _tb = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tb.backgroundColor = [UIColor clearColor];
        _tb.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tb.scrollEnabled = NO;
        _tb.dataSource = self;
        _tb.delegate = self;
        _tb.tableFooterView = [UIView new];
    }
    return _tb;
}

- (UILabel *)subLb
{
    if (!_subLb) {
        _subLb = [UILabel new];
        _subLb.font = [UIFont sf_systemFontOfSize:13];
        _subLb.text = @"请选择您要添加的设备类型:";
    }
    return _subLb;
}

@end
