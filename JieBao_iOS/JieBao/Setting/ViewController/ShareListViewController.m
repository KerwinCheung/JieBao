//
//  ShareListViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/17.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "ShareListViewController.h"
#import "BaseTableView.h"
#import "ShareListCell.h"
#import "ShareListHeaderView.h"


@interface ShareListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) BaseTableView *tb;

@property (nonatomic, strong) NSMutableArray<ShareModel *> *myShareDataSource;

@property (nonatomic, strong) NSMutableArray<ShareModel *> *otherShareDataSource;

@end

@implementation ShareListViewController

- (instancetype)init
{
    if (self = [super init]) {
    
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UICOLORFROMRGB(0xf8f8f8);
    [self initUI];
    [self requestMyShareData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];

    LHWeakSelf(self)
    
    ActionBlock rightAction = ^(UIButton *btn){
        [weakself showEdit];
        LHLog(@"left");
    };
    
    ActionBlock leftAction = ^(UIButton *btn){
        [weakself.navigationController popViewControllerAnimated:YES];
        LHLog(@"left");
    };
    [self.naviBar  configNavigationBarWithAttrs:@{
                                                  kCustomNaviBarLeftActionKey:leftAction,
                                                  kCustomNaviBarLeftImgKey:@"back",
                                                  kCustomNaviBarTitleKey:@"分享列表",
                                                  kCustomNaviBarRightImgKey:@"编辑",
                                                  kCustomNaviBarRightActionKey:rightAction
                                                  }];
}

- (void)initUI
{
    [self.view addSubview:self.tb];
    
}

- (void)showEdit
{
    [self.tb setEditing:YES animated:YES];
}

- (void)requestMyShareData
{
    [SVProgressHUD show];
    [NetworkHelper sendRequest:nil Method:@"GET" Path:@"https://api.gizwits.com/app/sharing?sharing_type=0" callback:^(NSData *data, NSError *error) {
        [self requestOtherShareData];
        if (!data || error) {
            return ;
        }
        NSDictionary *jsonObj =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (!jsonObj) {
            return;
        }
        
        for (NSDictionary *dic in jsonObj[@"objects"]) {
            ShareModel *model = [ShareModel yy_modelWithJSON:dic];
            [self.myShareDataSource addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tb reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        });
    }];
}

- (void)requestOtherShareData
{
    [NetworkHelper sendRequest:nil Method:@"GET" Path:@"https://api.gizwits.com/app/sharing?sharing_type=1" callback:^(NSData *data, NSError *error) {
        [SVProgressHUD dismiss];
        if (!data || error) {
            return ;
        }
        NSDictionary *jsonObj =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        
        if (!jsonObj) {
            return;
        }
        
        for (NSDictionary *dic in jsonObj[@"objects"]) {
            ShareModel *model = [ShareModel yy_modelWithJSON:dic];
            [self.otherShareDataSource addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tb reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        });
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"ShareListCell";
    ShareListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[ShareListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (indexPath.section == 1) {
        cell.dataDic = self.myShareDataSource[indexPath.row];
    }else
    {
        cell.dataDic = self.otherShareDataSource[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger num;
    if (section == 1) {
        num = self.myShareDataSource.count;
    }else
    {
        num = self.otherShareDataSource.count;
    }
    return num;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath

{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        if (indexPath.section == 0) {
            [self.otherShareDataSource removeObjectAtIndex:indexPath.row];
            [self.tb reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }else
        {
            if ([self.myShareDataSource[indexPath.row].status integerValue] == 1) {
                [NetworkHelper sendRequest:@{} Method:@"DELETE" Path:[NSString stringWithFormat:@"https://api.gizwits.com/app/sharing/%@",self.myShareDataSource[indexPath.row].sid] callback:^(NSData *data, NSError *error) {
                    if (!data || error) {
                        return ;
                    }
                    [self.myShareDataSource removeObjectAtIndex:indexPath.row];
                    [self.tb reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                }];
            }else
            {
                [self.myShareDataSource removeObjectAtIndex:indexPath.row];
                [self.tb reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headId = @"headId";
    ShareListHeaderView *headerV = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headId];
    if (!headerV) {
        headerV = [[ShareListHeaderView alloc] initWithReuseIdentifier:headId];
    }
    headerV.title = section == 0 ? @"分享给我的" : @"我分享的";
    if (section == 1) {
        if (self.myShareDataSource.count == 0) {
            return nil;
        }else
        {
            return headerV;
        }
    }else
    {
        if (self.otherShareDataSource.count == 0) {
            return nil;
        }else
        {
            return headerV;
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        if (self.myShareDataSource.count == 0) {
            return CurrentDeviceSize(0.01);
        }else
        {
            return  CurrentDeviceSize(30);
        }
    }else
    {
        if (self.otherShareDataSource.count == 0) {
           return  CurrentDeviceSize(0.01);
        }else
        {
            return  CurrentDeviceSize(30);
        }
    }
    return  CurrentDeviceSize(0.01);
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

- (NSMutableArray<ShareModel *> *)myShareDataSource
{
    if (!_myShareDataSource) {
        _myShareDataSource = [NSMutableArray array];
    }
    return _myShareDataSource;
}

- (NSMutableArray<ShareModel *> *)otherShareDataSource
{
    if (!_otherShareDataSource) {
        _otherShareDataSource = [NSMutableArray array];
    }
    return _otherShareDataSource;
}
@end
