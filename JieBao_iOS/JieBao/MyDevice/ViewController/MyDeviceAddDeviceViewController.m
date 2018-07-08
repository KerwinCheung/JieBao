//
//  AddDeviceViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/14.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "MyDeviceAddDeviceViewController.h"
#import "BaseTableView.h"
#import "EditAddGroupCell.h"

@interface MyDeviceAddDeviceViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UILabel *subLb;

@property (nonatomic, strong) BaseTableView *tb;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) NSArray<GizWifiDevice *> *dataSource;

@property (nonatomic, strong) NSMutableArray<GizWifiDevice *> *temps;

@end

@implementation MyDeviceAddDeviceViewController

- (instancetype)init
{
    if (self = [super init]) {
        _temps = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UICOLORFROMRGB(0xededed);
    [self initUI];
    [self discoverDevice];
    
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
                                                  kCustomNaviBarTitleKey:@"添加设备",
                                                  }];
}

- (void)initUI
{
    [self.bgView addSubview:self.subLb];
    [self.bgView addSubview:self.tb];
    [self.bgView addSubview:self.confirmBtn];
    
    LHWeakSelf(self)
    
    [self.subLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.top.equalTo(@(CurrentDeviceSize(20)));
        make.width.lessThanOrEqualTo(@200);
    }];
    
    [self.tb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(weakself.subLb.mas_bottom).offset(CurrentDeviceSize(5));
        make.height.equalTo(@(5*CurrentDeviceSize(44)));
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.right.equalTo(weakself.view.mas_right).offset(-CurrentDeviceSize(20));
        make.bottom.equalTo(weakself.view.mas_bottom).offset(-CurrentDeviceSize(100));
        make.height.equalTo(@(CurrentDeviceSize(35)));
    }];
}

- (void)discoverDevice
{
    LHWeakSelf(self)
    [SDKHelper shareInstance].discoverDeviceBlock = ^(NSArray *devs) {
        if (devs) {
            weakself.dataSource = devs;
            [weakself.tb reloadData];
        }
    };
    [[GizWifiSDK sharedInstance] getBoundDevices:[UserHelper getCurrentUser].uid token:[UserHelper getCurrentUser].token];
}

- (void)confirmBtnClicked
{
    [SDKHelper shareInstance].bindDeviceBlock = ^(BOOL success) {
        if (success) {
            [self.navigationController pushViewController:[NSClassFromString(@"MyDeviceAddSuccessViewController") new] animated:YES];
        }else
        {
            [self alertShowMessage:@"绑定失败" title:@"提示" confirmBtnText:@"确定" confirmCallback:nil];
        }
    };
    for (GizWifiDevice * dev in self.temps) {
        [[GizWifiSDK sharedInstance] bindRemoteDevice:[UserHelper getCurrentUser].uid token:[UserHelper getCurrentUser].token mac:dev.macAddress productKey:dev.productKey productSecret:[UserHelper shareInstance].productSecretKey beOwner:NO];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"EditAddGroupCell";
    EditAddGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[EditAddGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
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
    EditAddGroupCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelected];
    if ([cell getSelected]) {
        [self.temps addObject:self.dataSource[indexPath.row]];
    }else
    {
        [self.temps removeObject:self.dataSource[indexPath.row]];
    }
}

- (BaseTableView *)tb
{
    if (!_tb) {
        _tb = [[BaseTableView alloc] initWithFrame:CGRectMake(0, CurrentDeviceSize(40 + LL_StatusBarAndNavigationBarHeight), LL_ScreenWidth, LL_ScreenHeight) style:UITableViewStylePlain];
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

- (UIButton *)confirmBtn
{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton new];
        [_confirmBtn addTarget:self action:@selector(confirmBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_confirmBtn setTitle:@"确认添加" forState:UIControlStateNormal];
        [_confirmBtn setBackgroundImage:[UIImage imageNamed:@"btnBg"] forState:UIControlStateNormal];
        [_confirmBtn.titleLabel setTextColor:[UIColor whiteColor]];
        _confirmBtn.layer.masksToBounds = YES;
        _confirmBtn.layer.cornerRadius = CurrentDeviceSize(5);
    }
    return _confirmBtn;
}
@end

