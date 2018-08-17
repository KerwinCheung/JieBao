//
//  ZaoLangBengWeiShiViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/6/19.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "ShuiBengWeiShiViewController.h"
#import "BaseTableView.h"
#import "WeiShiSetStartViewController.h"
#import "SuiBengWeiShiCell.h"
#import "DeviceCommonSchulder.h"
#import "WeiShiSetStopViewController.h"

@interface ShuiBengWeiShiViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIView *switchBg;

@property (nonatomic, strong) UILabel *weishiLb;

@property (nonatomic, strong) UISwitch *weishiSwt;

@property (nonatomic, strong) UILabel *weishiStartLb;

@property (nonatomic, strong) UIView *addBg;

@property (nonatomic, strong) UILabel *addStartLb;

@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, strong) BaseTableView *tb;

@property (nonatomic, strong) UILabel *stopLb;

@property (nonatomic, strong) UIView *stopBg;

@property (nonatomic, strong) UILabel *addStopLb;

@property (nonatomic, strong) UIButton *transferBtn;

@property (nonatomic, strong) NSMutableArray<NSString *> *dataSource;

@property (nonatomic, strong) NSString *duringTime;

@end

@implementation ShuiBengWeiShiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.backgroundColor = UICOLORFROMRGB(0xf8f8f8);
    [self initUI];
    [self requestSch];
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
                                                  kCustomNaviBarTitleKey:@"喂食设置"
                                                  }];
}

- (void)initUI
{
    [self.bgView addSubview:self.switchBg];
    [self.switchBg addSubview:self.weishiLb];
    [self.switchBg addSubview:self.weishiSwt];
    
    [self.bgView addSubview:self.weishiStartLb];
    [self.bgView addSubview:self.addBg];
    [self.addBg addSubview:self.addStartLb];
    [self.addBg addSubview:self.addBtn];
    [self.bgView addSubview:self.tb];
    
    [self.bgView addSubview:self.stopLb];
    [self.bgView addSubview:self.stopBg];
    [self.stopBg addSubview:self.addStopLb];
    [self.stopBg addSubview:self.transferBtn];
    
    LHWeakSelf(self);
    [self.switchBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@(CurrentDeviceSize(44)));
        make.top.equalTo(@(CurrentDeviceSize(20)));
    }];
    
    [self.weishiLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.centerY.equalTo(weakself.switchBg);
        make.width.lessThanOrEqualTo(@200);
    }];
    
    [self.weishiSwt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.switchBg.mas_right).offset(-CurrentDeviceSize(20));
        make.centerY.equalTo(weakself.switchBg.mas_centerY).offset(-CurrentDeviceSize(6));
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(40), CurrentDeviceSize(20)));
    }];
    
    [self.weishiStartLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.weishiLb);
        make.top.equalTo(weakself.switchBg.mas_bottom).offset(CurrentDeviceSize(20));
        make.width.lessThanOrEqualTo(@200);
    }];
    
    [self.addBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@(CurrentDeviceSize(44)));
        make.top.equalTo(weakself.weishiStartLb.mas_bottom).offset(CurrentDeviceSize(10));
    }];
    
    [self.addStartLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.centerY.equalTo(weakself.addBg);
        make.width.lessThanOrEqualTo(@200);
    }];
    
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.switchBg.mas_right).offset(-CurrentDeviceSize(20));
        make.centerY.equalTo(weakself.addBg);
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(20), CurrentDeviceSize(20)));
    }];
    
    [self.tb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(weakself.addBg.mas_bottom);
        make.height.equalTo(@(3*CurrentDeviceSize(55)));
    }];
    
    [self.stopLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.weishiLb);
        make.top.equalTo(weakself.tb.mas_bottom).offset(CurrentDeviceSize(20));
        make.width.lessThanOrEqualTo(@200);
    }];
    
    [self.stopBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@(CurrentDeviceSize(44)));
        make.top.equalTo(weakself.stopLb.mas_bottom).offset(CurrentDeviceSize(10));
    }];
    
    [self.addStopLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.centerY.equalTo(weakself.stopBg);
        make.width.lessThanOrEqualTo(@200);
    }];
    
    [self.transferBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.switchBg.mas_right).offset(-CurrentDeviceSize(20));
        make.centerY.equalTo(weakself.stopBg);
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(20), CurrentDeviceSize(20)));
    }];
}

- (void)requestSch
{
    [HudHelper show];
    [NetworkHelper sendRequest:nil Method:@"GET" Path:[NSString stringWithFormat:@"https://api.gizwits.com/app/common_scheduler?did=%@",self.dev.did] callback:^(NSData *data, NSError *error) {
        [HudHelper dismiss];
        if (!data || error) {
            return ;
        }
        NSArray *jsonObj =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (!jsonObj) {
            return;
        }
        
        for (NSDictionary *dic in jsonObj) {
            DeviceCommonSchulder *model = [DeviceCommonSchulder yy_modelWithJSON:dic];
            [self.dataSource addObject:model.time];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tb reloadData];
        });
    }];
}

- (void)weishiSwtChanged
{
    
    for (NSString *time in self.dataSource) {
        NSDictionary *body = @{@"did":self.dev.did,@"attrs":@{@"mode":@(5),@"feedTime":self.duringTime},@"time":time,@"enabled":@(self.weishiSwt.selected)};
        [NetworkHelper sendRequest:body Method:@"POST" Path:@"https://api.gizwits.com/app/common_scheduler" callback:^(NSData *data, NSError *error) {
            if (!data || error) {
                return ;
            }
            NSDictionary *jsonObj =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            if (!jsonObj) {
                return;
            }
        }];
    }
}

- (void)addBtnClicked
{
    if (self.dataSource.count >= 3) {
        return;
    }
    LHWeakSelf(self);
    WeiShiSetStartViewController *vc = [WeiShiSetStartViewController new];
    vc.callBack = ^(NSString *obj) {
        [weakself.dataSource addObject:obj];
        [weakself.tb reloadData];
    };
    vc.dev = self.dev;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)transferBtnClicked
{
    LHWeakSelf(self);
    WeiShiSetStopViewController *vc = [WeiShiSetStopViewController new];
    vc.callBack = ^(NSString *obj) {
        weakself.duringTime = obj;
        weakself.addStopLb.text = [NSString stringWithFormat:@"%@ minute",obj];
    };
    vc.dev = self.dev;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"ZaoLangBengWeiShiCell";
    SuiBengWeiShiCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SuiBengWeiShiCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.text = self.dataSource[indexPath.row];
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

- (UIView *)switchBg
{
    if (!_switchBg) {
        _switchBg = [UIView new];
        _switchBg.backgroundColor = [UIColor whiteColor];
    }
    return _switchBg;
}

- (UILabel *)weishiLb
{
    if (!_weishiLb) {
        _weishiLb = [UILabel new];
        _weishiLb.font = [UIFont sf_systemFontOfSize:13];
        _weishiLb.text = @"喂食开关";
    }
    return _weishiLb;
}

- (UISwitch *)weishiSwt
{
    if (!_weishiSwt) {
        _weishiSwt = [UISwitch new];
        [_weishiSwt addTarget:self action:@selector(weishiSwtChanged) forControlEvents:UIControlEventValueChanged];
    }
    return _weishiSwt;
}

- (UILabel *)weishiStartLb
{
    if (!_weishiStartLb) {
        _weishiStartLb = [UILabel new];
        _weishiStartLb.font = [UIFont sf_systemFontOfSize:13];
        _weishiStartLb.text = @"喂食开始时间";
    }
    return _weishiStartLb;
}

- (UIView *)addBg
{
    if (!_addBg) {
        _addBg = [UIView new];
        _addBg.backgroundColor = [UIColor whiteColor];
    }
    return _addBg;
}

- (UILabel *)addStartLb
{
    if (!_addStartLb) {
        _addStartLb = [UILabel new];
        _addStartLb.font = [UIFont sf_systemFontOfSize:13];
        _addStartLb.text = @"添加开始时间";
    }
    return _addStartLb;
}

- (UIButton *)addBtn
{
    if (!_addBtn) {
        _addBtn = [UIButton new];
        [_addBtn setImage:[UIImage imageNamed:@"tianjia2"] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

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

- (UILabel *)stopLb
{
    if (!_stopLb) {
        _stopLb = [UILabel new];
        _stopLb.font = [UIFont sf_systemFontOfSize:13];
        _stopLb.text = @"喂食暂停时间";
    }
    return _stopLb;
}

- (UIView *)stopBg
{
    if (!_stopBg) {
        _stopBg = [UIView new];
        _stopBg.backgroundColor = [UIColor whiteColor];
    }
    return _stopBg;
}

- (UILabel *)addStopLb
{
    if (!_addStopLb) {
        _addStopLb = [UILabel new];
        _addStopLb.font = [UIFont sf_systemFontOfSize:13];
        _addStopLb.text = @"添加暂停时间";
    }
    return _addStopLb;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UIButton *)transferBtn
{
    if (!_transferBtn) {
        _transferBtn = [UIButton new];
        [_transferBtn setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
        [_transferBtn addTarget:self action:@selector(transferBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _transferBtn;
}

@end
