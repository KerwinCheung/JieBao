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


@property (nonatomic, strong) NSMutableArray<ShareModel *> *myShareDataSource;

@property (nonatomic, strong) NSMutableArray<ShareModel *> *otherShareDataSource;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *noDataView;

@end

@implementation ShareListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self requestMyShareData];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = 85;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
    [self configNavWithEdit:NO];
    self.bgView.hidden = YES;
    
    
}

-(void)configNavWithEdit:(BOOL)isEdit{
    LHWeakSelf(self)

    if (isEdit) {
        //编辑状态
        ActionBlock rightAction = ^(UIButton *btn){
            [weakself showEdit];
        };
        
        ActionBlock leftAction = ^(UIButton *btn){
            [weakself.navigationController popViewControllerAnimated:YES];
        };
        [self.naviBar  configNavigationBarWithAttrs:@{
                                                      kCustomNaviBarLeftActionKey:leftAction,
                                                      kCustomNaviBarLeftImgKey:@"back",
                                                      kCustomNaviBarTitleKey:@"分享列表",
                                                      kCustomNaviBarRightImgKey:@"queding1",
                                                      kCustomNaviBarRightActionKey:rightAction
                                                      }];
    }else{
        //非编辑状态
        ActionBlock rightAction = ^(UIButton *btn){
            [weakself showEdit];
        };
        
        ActionBlock leftAction = ^(UIButton *btn){
            [weakself.navigationController popViewControllerAnimated:YES];
        };
        [self.naviBar  configNavigationBarWithAttrs:@{
                                                      kCustomNaviBarLeftActionKey:leftAction,
                                                      kCustomNaviBarLeftImgKey:@"back",
                                                      kCustomNaviBarTitleKey:@"分享列表",
                                                      kCustomNaviBarRightImgKey:@"bianji",
                                                      kCustomNaviBarRightActionKey:rightAction
                                                      }];
    }
}

- (void)showEdit
{
    [self.tableView setEditing:!self.tableView.editing animated:YES];
    [self configNavWithEdit:self.tableView.editing];
}

- (void)requestMyShareData
{
    [HudHelper show];
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
            if (self.otherShareDataSource.count>0||self.myShareDataSource.count > 0) {
                self.noDataView.hidden = YES;
                self.tableView.hidden = NO;
            }else{
                self.noDataView.hidden = NO;
                self.tableView.hidden = YES;
            }
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
        });
    }];
}

- (void)requestOtherShareData
{
    [NetworkHelper sendRequest:nil Method:@"GET" Path:@"https://api.gizwits.com/app/sharing?sharing_type=1" callback:^(NSData *data, NSError *error) {
        [HudHelper dismiss];
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
            if (self.otherShareDataSource.count>0||self.myShareDataSource.count > 0) {
                self.noDataView.hidden = YES;
                self.tableView.hidden = NO;
            }else{
                self.noDataView.hidden = NO;
                self.tableView.hidden = YES;
            }
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        });
    }];
}

#pragma mark - tableView Delegate|DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"ShareListCell";
    ShareListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (indexPath.section == 1) {
        cell.shareModel = self.myShareDataSource[indexPath.row];
    }else{
        cell.shareModel = self.otherShareDataSource[indexPath.row];
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
    }else{
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
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
        }else
        {
            if ([self.myShareDataSource[indexPath.row].status integerValue] == 1) {
                [NetworkHelper sendRequest:@{} Method:@"DELETE" Path:[NSString stringWithFormat:@"https://api.gizwits.com/app/sharing/%@",self.myShareDataSource[indexPath.row].sid] callback:^(NSData *data, NSError *error) {
                    if (!data || error) {
                        return ;
                    }
                    [self.myShareDataSource removeObjectAtIndex:indexPath.row];
                    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
                }];
            }else
            {
                [self.myShareDataSource removeObjectAtIndex:indexPath.row];
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!tableView.editing) {
        //不为编辑
        if (indexPath.section == 0) {
            // 分享给我的
            ShareModel *shareModel = self.otherShareDataSource[indexPath.row];
            if (shareModel.status.integerValue == 0) {
                [self alertShowMessage:[NSString stringWithFormat:@"账号：%@向您分享了一台设备?",shareModel.phone] title:@"提示" leftBtnText:@"取消" rightBtnText:@"接受分享" leftCallback:nil rightCallback:^{
                    [GizDeviceSharing acceptDeviceSharing:[UserHelper getCurrentUser].token sharingID:shareModel.sid.integerValue accept:YES];
                }];
            }
        }
    }
}

#pragma mark - Giz ShareDelegate
// 实现接受分享邀请的回调
- (void)didAcceptDeviceSharing:(NSError*)result sharingID:(NSInteger)sharingID {
    if(result.code == GIZ_SDK_SUCCESS) {
        // 接受成功
        [self requestOtherShareData];
    } else {
        // 接受失败
    }
}

#pragma mark - lazy init
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
