//
//  SettingViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/12.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingHeadView.h"
#import "LoginViewController.h"
#import "BaseTableView.h"
#import "SettingContentCell.h"
#import "AppDelegate.h"
#import "ShareListViewController.h"
@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) SettingHeadView *headView;

@property (nonatomic, strong) BaseTableView *tb;

@property (nonatomic, strong) UIButton *logoutBtn;

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation SettingViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.dataSource =  @[
                             @{kSettingImgKey:@"shell",kSettingTextKey:@"分享列表",kSettingRightImgKey:@"next"},
                             @{kSettingImgKey:@"guzhang",kSettingTextKey:@"故障列表",kSettingRightImgKey:@"next"},
                             @{kSettingImgKey:@"kongzhi",kSettingTextKey:@"AP控制",kSettingRightImgKey:@"next"},
                             @{kSettingImgKey:@"help",kSettingTextKey:@"使用帮助",kSettingRightImgKey:@"next"},
                             @{kSettingImgKey:@"me",kSettingTextKey:@"关于我们",kSettingRightImgKey:@"next"},
                             @{kSettingImgKey:@"banben",kSettingTextKey:@"版本信息",kSettingRightImgKey:@"next"}
                             ];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}

- (void)initUI
{
    self.view.backgroundColor = UICOLORFROMRGB(0xf0f0f0);
    [self.view addSubview:self.headView];
    [self.view addSubview:self.tb];
    [self.view addSubview:self.logoutBtn];
    
    LHWeakSelf(self)
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.height.equalTo(@(CurrentDeviceSize(200)));
        make.top.equalTo(@0);
    }];
    
    [self.tb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(30)));
        make.right.equalTo(weakself.view.mas_right).offset(-CurrentDeviceSize(30));
        make.height.equalTo(@(self.dataSource.count*CurrentDeviceSize(44)));
        make.top.equalTo(weakself.headView.mas_bottom).offset(-CurrentDeviceSize(20));
    }];
    
    [self.logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.tb.mas_bottom).offset(CurrentDeviceSize(30));
        make.left.equalTo(@(CurrentDeviceSize(30)));
        make.right.equalTo(weakself.view.mas_right).offset(-CurrentDeviceSize(30));
        make.height.equalTo(@(CurrentDeviceSize(40)));
    }];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self.tabBarController.tabBar setHidden:NO];

}


- (void)logoutBtnCilcked
{
   
    UIStoryboard *loginSB = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
    UIViewController *vc = [loginSB instantiateViewControllerWithIdentifier:@"NavigationController"];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delegate.window.rootViewController = vc;
    [delegate.window makeKeyAndVisible];
}



#pragma mark - tableView Delegate |DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"SettingContentCell";
    SettingContentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[SettingContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.dataDic = self.dataSource[indexPath.row];
    if (indexPath.row == self.dataSource.count - 1) {
        cell.dataDic = self.dataSource[indexPath.row];
        cell.versionStr = [NSString stringWithFormat:@"V%@.%@",[[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleShortVersionString"],[[[NSBundle mainBundle]infoDictionary] objectForKey:@"CFBundleVersion"]];
        
    }
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
    switch (indexPath.row) {
        case 0:
//            [self.navigationController pushViewController:[NSClassFromString(@"ShareListViewController") new] animated:YES];
        {
            UIStoryboard *settingSB = [UIStoryboard storyboardWithName:@"SettingStoryboard" bundle:nil];
            ShareListViewController *shareListVC = [settingSB instantiateViewControllerWithIdentifier:@"ShareListViewController"];
            [self.navigationController pushViewController:shareListVC animated:YES];
        }
            break;
        case 1:
            [self.navigationController pushViewController:[NSClassFromString(@"ErrorListViewController") new] animated:YES];
            break;
        case 2:
            [self.navigationController pushViewController:[NSClassFromString(@"APControlViewController") new] animated:YES];
            break;
        case 3:
            [self.navigationController pushViewController:[NSClassFromString(@"HelpViewController") new] animated:YES];
            break;
        case 4:
            [self.navigationController pushViewController:[NSClassFromString(@"HelpViewController") new] animated:YES];
            break;
            
        default:
            break;
    }
}

#pragma mark - lazy init
- (SettingHeadView *)headView
{
    if (!_headView) {
        _headView = [[SettingHeadView alloc] init];
        _headView.currentUser = [UserHelper getCurrentUser];
    }
    return _headView;
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
        _tb.layer.masksToBounds = YES;
        _tb.layer.cornerRadius = CurrentDeviceSize(5);
        _tb.tableFooterView = [UIView new];
    }
    return _tb;
}

- (UIButton *)logoutBtn
{
    if (!_logoutBtn) {
        _logoutBtn = [UIButton new];
        [_logoutBtn addTarget:self action:@selector(logoutBtnCilcked) forControlEvents:UIControlEventTouchUpInside];
        [_logoutBtn.titleLabel setFont:[UIFont sf_systemFontOfSize:16]];
        [_logoutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _logoutBtn.layer.masksToBounds = YES;
        _logoutBtn.layer.cornerRadius = CurrentDeviceSize(5);
        [_logoutBtn setBackgroundImage:[UIImage imageNamed:@"tuichu"] forState:UIControlStateNormal];
        [_logoutBtn setTitle:@"退出" forState:UIControlStateNormal];
    }
    return _logoutBtn;
}

- (void)setCurrentUser:(UserModel *)currentUser
{
    if (currentUser) {
        self.headView.currentUser = currentUser;
        [self.logoutBtn setBackgroundColor:kAPPThemeColor];
    }
}
@end
