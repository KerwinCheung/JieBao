//
//  AddGroupViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/14.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "MyDeviceAddViewController.h"
#import "BaseTableView.h"
#import "AddDeviceCell.h"
#import "MyDeviceAddNextViewController.h"
@interface MyDeviceAddViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) BaseTableView *tb;

@property (nonatomic, strong) UILabel *subLb;

@property (nonatomic, strong) NSArray<DeviceModel *> *dataSource;

@property (nonatomic, strong) NSArray *secKeys;

@end

@implementation MyDeviceAddViewController

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
        self.dataSource = @[zaolangBeng,diandiBeng,shuiBeng,wuxianKaiguan,caideng];
        
        self.secKeys = @[@"b714e185a5a44b779e52d8d0590f3765",
                         @"07ea749f7dd243ac9f6c666ce8d890be",
                         @"51d3684f569444ac89d3c399962e645e",
                         @"b4fd93cfb1624519addfb630f8346411",
                         @"d293290d7e52449a96a629d7857d57e9"];
        
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"AddDeviceCell";
    AddDeviceCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[AddDeviceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
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
    
    [UserHelper shareInstance].productSecretKey = self.secKeys[indexPath.row];
    UIStoryboard *addSB = [UIStoryboard storyboardWithName:@"AddDeviceStoryboard" bundle:nil];
    MyDeviceAddNextViewController *addNextVC = [addSB instantiateViewControllerWithIdentifier:@"MyDeviceAddNextViewController"];
    [self.navigationController pushViewController:addNextVC animated:YES];
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

