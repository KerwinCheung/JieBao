//
//  WeiShiTimingViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/5/21.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "WeiShiTimingViewController.h"
#import "BaseTableView.h"
#import "ShuiBengTimingCell.h"

@interface WeiShiTimingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray<DeviceSchedulerTask *> *dataSource;

@property (nonatomic, strong) UIView *noTimingView;

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *subLb;

@property (nonatomic, strong) UIButton *addTimingBtn;

@property (nonatomic, strong) UIButton *confirmUseBtn;

@property (nonatomic, strong) BaseTableView *tb;

@end

@implementation WeiShiTimingViewController

- (instancetype)init
{
    if (self = [super init]) {
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
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
                                                  kCustomNaviBarTitleKey:@"定时模式"
                                                  }];
}

- (void)initUI
{
    [self.bgView addSubview:self.tb];
    [self.bgView addSubview:self.confirmUseBtn];
    [self.bgView addSubview:self.noTimingView];
    [self.noTimingView addSubview:self.imgView];
    [self.noTimingView addSubview:self.subLb];
    [self.noTimingView addSubview:self.addTimingBtn];
    
    [self makeContraints];
}

- (void)makeContraints
{
    LHWeakSelf(self)
    [self.tb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(@(CurrentDeviceSize(40)));
        make.bottom.equalTo(weakself.confirmUseBtn.mas_top).offset(-CurrentDeviceSize(100));
    }];
    
    [self.confirmUseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.right.equalTo(weakself.noTimingView.mas_right).offset(-CurrentDeviceSize(20));
        make.bottom.equalTo(weakself.noTimingView.mas_bottom).offset(-CurrentDeviceSize(20));
        make.height.equalTo(@(CurrentDeviceSize(40)));
    }];
    
    [self.noTimingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakself.bgView).insets(UIEdgeInsetsZero);
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.noTimingView);
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(160), CurrentDeviceSize(80)));
        make.centerY.equalTo(weakself.noTimingView.mas_centerY).offset(-CurrentDeviceSize(20));
    }];
    
    [self.subLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.noTimingView);
        make.top.equalTo(weakself.imgView.mas_bottom).offset(CurrentDeviceSize(20));
        make.width.lessThanOrEqualTo(@200);
    }];
    
    [self.addTimingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.right.equalTo(weakself.noTimingView.mas_right).offset(-CurrentDeviceSize(20));
        make.bottom.equalTo(weakself.noTimingView.mas_bottom).offset(-CurrentDeviceSize(20));
        make.height.equalTo(@(CurrentDeviceSize(40)));
    }];
    
    
}

- (void)addTimingBtnClicked
{
    
}

- (void)confirmUseBtnClicked
{
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"ZaoLangBengWeiShiCell";
    ShuiBengTimingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ShuiBengTimingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
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

- (UIView *)noTimingView
{
    if (!_noTimingView) {
        _noTimingView = [UIView new];
    }
    return _noTimingView;
}

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [UIImageView new];
        _imgView.image = [UIImage imageNamed:@""];
    }
    return _imgView;
}


- (UILabel *)subLb
{
    if (!_subLb) {
        _subLb = [UILabel new];
        _subLb.font = [UIFont sf_systemFontOfSize:13];
        _subLb.text = @"暂无定时模式";
    }
    return _subLb;
}

- (UIButton *)addTimingBtn
{
    if (!_addTimingBtn) {
        _addTimingBtn = [UIButton new];
        [_addTimingBtn setBackgroundColor:kAPPThemeColor];
        [_addTimingBtn setTitle:@"添加定时模式" forState:UIControlStateNormal];
        [_addTimingBtn addTarget:self action:@selector(addTimingBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addTimingBtn;
}

- (UIButton *)confirmUseBtn
{
    if (!_confirmUseBtn) {
        _confirmUseBtn = [UIButton new];
        [_confirmUseBtn setBackgroundImage:[UIImage imageNamed:@"btnBg"] forState:UIControlStateNormal];
        [_confirmUseBtn.titleLabel setTextColor:[UIColor whiteColor]];
        [_confirmUseBtn setTitle:@"确认使用" forState:UIControlStateNormal];
        [_confirmUseBtn addTarget:self action:@selector(confirmUseBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmUseBtn;
}

- (BaseTableView *)tb
{
    if (!_tb) {
        _tb = [[BaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tb.delegate = self;
        _tb.dataSource = self;
        _tb.tableFooterView = [UIView new];
    }
    return _tb;
}
@end
