//
//  ChannelDetailViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/5/14.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "WirelessTurnDetailViewController.h"
#import "BaseTableView.h"
#import "ChannelDetailCell.h"
#import "WirelessTurnSetTimingViewController.h"

@interface WirelessTurnDetailViewController ()<UITableViewDataSource,UITableViewDelegate,ChannelDetailCellDelegate>

@property (nonatomic, strong) UILabel *timeSubLb;

@property (nonatomic, strong) UIView *timeAddBgView;

@property (nonatomic, strong) UILabel *timeingAddLb;

@property (nonatomic, strong) UIButton *timeingAddBtn;

@property (nonatomic, strong) UIView *sepline;

@property (nonatomic, strong) BaseTableView *tb;

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation WirelessTurnDetailViewController

- (instancetype)init
{
    if (self = [super init]) {
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.bgView.backgroundColor = UICOLORFROMRGB(0xededed);
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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
                                                  kCustomNaviBarTitleKey:@"CH1",
                                                  kCustomNaviBarRightImgKey:@"保存",
                                                  kCustomNaviBarRightActionKey:rightAction
                                                  }];
}

- (void)initUI
{
    [self.bgView addSubview:self.timeSubLb];
    [self.bgView addSubview:self.timeAddBgView];
    [self.timeAddBgView addSubview:self.timeingAddLb];
    [self.timeAddBgView addSubview:self.timeingAddBtn];
    [self.bgView addSubview:self.sepline];
    [self.bgView addSubview:self.tb];
    
    LHWeakSelf(self)
    
    [self.timeSubLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.top.equalTo(@(CurrentDeviceSize(40)));
        make.width.lessThanOrEqualTo(@200);
    }];
    
    [self.timeAddBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(weakself.timeSubLb.mas_bottom);
        make.height.equalTo(@(CurrentDeviceSize(44)));
    }];
    
    [self.timeingAddLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.timeSubLb);
        make.top.bottom.equalTo(@0);
        make.width.equalTo(@100);
    }];
    
    [self.timeingAddBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.bgView.mas_right).offset(-CurrentDeviceSize(20));
        make.centerY.equalTo(weakself.timeingAddLb.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(20), CurrentDeviceSize(20)));;
    }];
    
    [self.sepline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(10)));
        make.top.equalTo(weakself.timeAddBgView.mas_bottom);
        make.height.equalTo(@(CurrentDeviceSize(0.5)));
        make.right.equalTo(weakself.bgView.mas_right).offset(-CurrentDeviceSize(10));
    }];
    
    [self.tb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(weakself.timeAddBgView.mas_bottom);
        make.height.equalTo(@(CurrentDeviceSize(5*CurrentDeviceSize(44))));
    }];
}

- (void)save
{
    
}

- (void)timeingAddBtnClicked
{
    WirelessTurnSetTimingViewController *vc = [WirelessTurnSetTimingViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tranferToSetChannelTime
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"ChannelDetailCell";
    ChannelDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ChannelDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
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

- (UILabel *)timeSubLb
{
    if (!_timeSubLb) {
        _timeSubLb = [UILabel new];
        _timeSubLb.text = @"时间段";
        _timeSubLb.font = [UIFont sf_systemFontOfSize:13];
        _timeSubLb.textAlignment = NSTextAlignmentLeft;
    }
    return _timeSubLb;
}


- (UIView *)timeAddBgView
{
    if (!_timeAddBgView) {
        _timeAddBgView = [UIView new];
        _timeAddBgView.backgroundColor = [UIColor whiteColor];
    }
    return _timeAddBgView;
}

- (UILabel *)timeingAddLb
{
    if (!_timeingAddLb) {
        _timeingAddLb = [UILabel new];
        _timeingAddLb.text = @"添加时间段";
        _timeingAddLb.font = [UIFont sf_systemFontOfSize:13];
        _timeingAddLb.textAlignment = NSTextAlignmentLeft;
    }
    return _timeingAddLb;
}

- (UIButton *)timeingAddBtn
{
    if (!_timeingAddBtn) {
        _timeingAddBtn = [UIButton new];
        [_timeingAddBtn setImage:[UIImage imageNamed:@"tianjia2"] forState:UIControlStateNormal];
        [_timeingAddBtn addTarget:self action:@selector(timeingAddBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _timeingAddBtn;
}

- (UIView *)sepline
{
    if (!_sepline) {
        _sepline = [UIView new];
        _sepline.backgroundColor  = [UIColor lightGrayColor];
    }
    return _sepline;
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
@end
