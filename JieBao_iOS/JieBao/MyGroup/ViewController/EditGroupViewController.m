//
//  EditGroupViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/14.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//   编辑分组

#import "EditGroupViewController.h"
#import "BaseTableView.h"
#import "EditGroupCell.h"
#import "ManagerDeviceViewController.h"
#import "UIViewController+Custom.h"

@interface EditGroupViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UILabel *groupLb;

@property (nonatomic, strong) UITextField *groupNameTv;

@property (nonatomic, strong) UIView *nameBgView;

@property (nonatomic, strong) UILabel *deviceLb;

@property (nonatomic, strong) BaseTableView *tb;

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation EditGroupViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.dataSource =  @[
                             @{kSettingImgKey:@"shell",kSettingTextKey:@"管理分组设备",kSettingRightImgKey:@"next"}
                             ];
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
        [weakself save];
        LHLog(@"保存");
    };
    
    ActionBlock leftAction = ^(UIButton *btn){
        [weakself.navigationController popViewControllerAnimated:YES];
        LHLog(@"left");
    };
    [self.naviBar  configNavigationBarWithAttrs:@{
                                                  kCustomNaviBarLeftActionKey:leftAction,
                                                  kCustomNaviBarLeftImgKey:@"back",
                                                  kCustomNaviBarTitleKey:@"编辑分组",
                                                  kCustomNaviBarRightImgKey:@"baocun",
                                                  kCustomNaviBarRightActionKey:rightAction
                                                  }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)initUI{
    [self.view addSubview:self.groupLb];
    [self.view addSubview:self.nameBgView];
    [self.nameBgView addSubview:self.groupNameTv];
    [self.view addSubview:self.tb];
    [self.view addSubview:self.deviceLb];
    
    [self makeContraints];
}

- (void)makeContraints
{
    LHWeakSelf(self)
    [self.groupLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.top.equalTo(@(CurrentDeviceSize(40 + LL_StatusBarAndNavigationBarHeight)));
        make.width.lessThanOrEqualTo(@200);
    }];
    
    [self.nameBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(weakself.groupLb.mas_bottom).offset(CurrentDeviceSize(5));
        make.height.equalTo(@(CurrentDeviceSize(40)));
    }];
    
    [self.groupNameTv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.groupLb.mas_left);
        make.top.bottom.right.equalTo(@0);
    }];
    
    [self.deviceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.groupLb.mas_left);
        make.top.equalTo(weakself.groupNameTv.mas_bottom).offset(CurrentDeviceSize(40));
        make.width.lessThanOrEqualTo(@200);
    }];
    
    [self.tb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(weakself.deviceLb.mas_bottom).offset(CurrentDeviceSize(5));
        make.height.equalTo(@(CurrentDeviceSize(44)*self.dataSource.count));
    }];
}

- (void)save
{
    [NetworkHelper sendRequest:@{@"group_name":self.groupNameTv.text} Method:@"PUT" Path:[NSString stringWithFormat:@"https://api.gizwits.com/app/group/%@",self.group.gid] callback:^(NSData *data, NSError *error) {
        if (error) {
            return ;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self alertShowMessage:@"编辑成功" title:@"提示" confirmCallback:nil cancelCallback:nil];
        });
    }];
}

#pragma mark - tableView Delegate|DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"EditAddGroupCell";
    EditGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[EditGroupCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
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
    ManagerDeviceViewController *vc = [ManagerDeviceViewController new];
    vc.group = self.group;
    [self.navigationController pushViewController:vc animated:YES];
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

- (UILabel *)groupLb
{
    if (!_groupLb) {
        _groupLb = [UILabel new];
        _groupLb.font = [UIFont sf_systemFontOfSize:13];
        _groupLb.text = @"重命名分组";
    }
    return _groupLb;
}


- (UILabel *)deviceLb
{
    if (!_deviceLb) {
        _deviceLb = [UILabel new];
        _deviceLb.font = [UIFont sf_systemFontOfSize:13];
        _deviceLb.text = @"设备管理";
    }
    return _deviceLb;
}

- (UITextField *)groupNameTv
{
    if (!_groupNameTv) {
        _groupNameTv = [UITextField new];
        _groupNameTv.placeholder = @"请输入分组名称";
        _groupNameTv.text = self.group.group_name;
        _groupNameTv.font = [UIFont sf_systemFontOfSize:13];
        _groupNameTv.backgroundColor = [UIColor whiteColor];
    }
    return _groupNameTv;
}

- (UIView *)nameBgView
{
    if (!_nameBgView) {
        _nameBgView = [UIView new];
        [_nameBgView setBackgroundColor:UICOLORFROMRGB(0xFFFFFF)];
    }
    return _nameBgView;
}

@end
