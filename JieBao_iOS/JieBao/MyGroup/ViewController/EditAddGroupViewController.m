//
//  EditGroupViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/14.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "EditAddGroupViewController.h"
#import "EditAddGroupCell.h"
#import "BaseTableView.h"
#import "UIViewController+Custom.h"
#import "UIViewController+Custom.h"
#import "CustomDevice.h"
#import "CustomDeviceGroup.h"
#import "LWHttpRequest.h"
@interface EditAddGroupViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UILabel *groupLb;

@property (nonatomic, strong) UITextField *groupNameTv;

@property (nonatomic, strong) UIView *nameBgView;

@property (nonatomic, strong) UILabel *deviceLb;

@property (nonatomic, strong) BaseTableView *tb;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) NSMutableArray<GizWifiDevice *> *dataSource;

@property (nonatomic, strong) NSMutableArray<GizWifiDevice *> *temps;

@end

@implementation EditAddGroupViewController

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
    [self discoverDevice];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)initUI
{
    [self.bgView addSubview:self.groupLb];
    [self.bgView addSubview:self.nameBgView];
    [self.nameBgView addSubview:self.groupNameTv];
    [self.bgView addSubview:self.deviceLb];
    [self.bgView addSubview:self.tb];
    [self.bgView addSubview:self.confirmBtn];
    
    [self makeContraints];
}

- (void)makeContraints
{
    LHWeakSelf(self)
    [self.groupLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.top.equalTo(@(CurrentDeviceSize(40)));
        make.width.lessThanOrEqualTo(@200);
    }];
    
    [self.nameBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(weakself.groupLb.mas_bottom).offset(CurrentDeviceSize(5));
        make.height.equalTo(@(CurrentDeviceSize(40)));
    }];
    
    [self.groupNameTv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.groupLb.mas_left);
        make.top.right.bottom.equalTo(@0);
    }];
    
    [self.deviceLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.groupLb.mas_left);
        make.top.equalTo(weakself.groupNameTv.mas_bottom).offset(CurrentDeviceSize(40));
        make.width.lessThanOrEqualTo(@200);
    }];
    
    [self.tb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(weakself.deviceLb.mas_bottom).offset(CurrentDeviceSize(5));
        make.height.equalTo(@(CurrentDeviceSize(44)*5));
    }];
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.right.equalTo(weakself.view.mas_right).offset(-CurrentDeviceSize(20));
        make.bottom.equalTo(weakself.view.mas_bottom).offset(-CurrentDeviceSize(100));
        make.height.equalTo(@(CurrentDeviceSize(35)));
    }];
}

#pragma mark - method
- (void)discoverDevice
{

    [self.dataSource removeAllObjects];
    for (GizWifiDevice *dev in SDKHELPER.deviceArray) {
        if ([dev.productKey isEqualToString:[UserHelper shareInstance].productSecretKey]) {
            BOOL isExisting = NO;
            for (CustomDeviceGroup *group in SDKHELPER.groupsArray) {
                for (CustomDevice *customDev in group.devs) {
                    if ([customDev.did isEqualToString:dev.did]) {
                        isExisting = YES;
                        break;
                    }
                }
            }
            if (!isExisting) {
                [self.dataSource addObject:dev];
            }
        }
    }
    [self.tb reloadData];
}

- (void)confirmBtnClicked
{
    if (self.temps.count == 0) {
        [HudHelper showErrorWithStatus:@"请选择设备"];
        return;
    }
    if (self.groupNameTv.text.length == 0) {
        [HudHelper showErrorWithStatus:@"请输入分组名称"];
        return;
    }
    NSString *path = @"https://api.gizwits.com/app/group";
    NSString *method = @"POST";
    NSDictionary *body = @{
                           @"product_key":self.temps[0].productKey,
                           @"group_name": self.groupNameTv.text
                           };
    
    [NetworkHelper sendRequest:body Method:method Path:path callback:^(NSData *data, NSError *error) {
        if (!data || error) {
            return;
        }
        NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        [self addDevWithGroupId:jsonObject[@"id"]];
    }];
}

- (void)addDevWithGroupId:(NSString *)groupId
{
    NSMutableArray *ids = [NSMutableArray array];
    for (GizWifiDevice *dev in self.temps) {
        [ids addObject:dev.did];
    }
    
    NSDictionary *body = @{@"dids":ids};
    [HudHelper show];
    [NetworkHelper sendRequest:body Method:@"POST" Path:[NSString stringWithFormat:@"https://api.gizwits.com/app/group/%@/devices",groupId] callback:^(NSData *data, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [HudHelper dismiss];
        });
        if (!data || error) {
            return;
        }
        [self getAddDevsTimerListWithArray:self.temps];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        });
    }];
}

-(void)getAddDevsTimerListWithArray:(NSArray *)addDevArray{
    for (CustomDevice *dev in addDevArray) {
        [LWHttpRequest getTimerListWithDid:dev.did didLoadData:^(NSArray *result, NSError *err) {
            if (!err) {
                if (!result) {
                    return ;
                }
                
                for (DeviceCommonSchulder *sch in result) {
                    if (sch.enabled) {
                        //关闭定时器
                        [LWHttpRequest closeTimerWithSchulder:sch didLoadData:^(id result, NSError *err) {
                            if (err) {
                                NSLog(@"关闭定时器失败，定时器：%@",sch.sid);
                            }
                        }];
                    }
                }
            }
        }];
    }
}

#pragma mark - tableView Delegate|DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"OpenGroupCell";
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
        _groupLb.text = @"分组名称:";
    }
    return _groupLb;
}


- (UILabel *)deviceLb
{
    if (!_deviceLb) {
        _deviceLb = [UILabel new];
        _deviceLb.font = [UIFont sf_systemFontOfSize:13];
        _deviceLb.text = @"分组设备:";
    }
    return _deviceLb;
}

- (UITextField *)groupNameTv
{
    if (!_groupNameTv) {
        _groupNameTv = [UITextField new];
        _groupNameTv.placeholder = @"请输入分组名称";
        _groupNameTv.font = [UIFont sf_systemFontOfSize:13];
        _groupNameTv.backgroundColor = [UIColor whiteColor];
    }
    return _groupNameTv;
}

- (UIButton *)confirmBtn
{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton new];
        [_confirmBtn addTarget:self action:@selector(confirmBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_confirmBtn setTitle:@"确认添加" forState:UIControlStateNormal];
        _confirmBtn.layer.masksToBounds = YES;
        _confirmBtn.layer.cornerRadius = CurrentDeviceSize(5);
        [_confirmBtn setBackgroundImage:[UIImage imageNamed:@"btnBg"] forState:UIControlStateNormal];
        [_confirmBtn.titleLabel setTextColor:[UIColor whiteColor]];
    }
    return _confirmBtn;
}

- (UIView *)nameBgView
{
    if (!_nameBgView) {
        _nameBgView = [UIView new];
        [_nameBgView setBackgroundColor:UICOLORFROMRGB(0xFFFFFF)];
    }
    return _nameBgView;
}

- (NSMutableArray<GizWifiDevice *> *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


- (NSMutableArray<GizWifiDevice *> *)temps
{
    if (!_temps) {
        _temps = [NSMutableArray array];
    }
    return _temps;
}
@end
