//
//  ErrorListViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/18.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "ErrorListViewController.h"
#import "BaseTableView.h"
#import "ErrorListCell.h"

@interface ErrorListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) BaseTableView *tb;

@property (nonatomic, strong) NSArray<ErrorModel *> *dataSource;

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *tipLb;

@end

@implementation ErrorListViewController

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UICOLORFROMRGB(0xededed);
    self.dataSource = [UtilHelper getErrorLists];
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
                                                  kCustomNaviBarTitleKey:@"故障列表"
                                                  }];
}

- (void)initUI
{
    if (self.dataSource.count == 0) {
        [self.view addSubview:self.imgView];
        [self.view addSubview:self.tipLb];
        
        LHWeakSelf(self)
        [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_offset(CGSizeMake(CurrentDeviceSize(160), CurrentDeviceSize(80)));
            make.centerY.equalTo(weakself.view.mas_centerY).offset(-CurrentDeviceSize(20));
            make.centerX.equalTo(weakself.view.mas_centerX);
        }];
        
        [self.tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.lessThanOrEqualTo(@200);
            make.top.equalTo(weakself.imgView.mas_bottom).offset(-CurrentDeviceSize(40));
            make.centerX.equalTo(weakself.view.mas_centerX);
        }];
        
    }else
    {
         [self.view addSubview:self.tb];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"ErrorListCell";
    ErrorListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ErrorListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
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

- (BaseTableView *)tb
{
    if (!_tb) {
        _tb = [[BaseTableView alloc] initWithFrame:CGRectMake(0, LL_StatusBarAndNavigationBarHeight, LL_ScreenWidth, LL_ScreenHeight - LL_StatusBarAndNavigationBarHeight) style:UITableViewStylePlain];
        _tb.backgroundColor = [UIColor clearColor];
        _tb.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tb.dataSource = self;
        _tb.delegate = self;
        _tb.tableFooterView = [UIView new];
    }
    return _tb;
}

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [UIImageView new];
        _imgView.image = [UIImage imageNamed:@""];
    }
    return _imgView;
}

- (UILabel *)tipLb
{
    if (!_tipLb) {
        _tipLb = [UILabel new];
        _tipLb.font = [UIFont sf_systemFontOfSize:15];
        _tipLb.text = @"暂无故障";
    }
    return _tipLb;
}
@end
