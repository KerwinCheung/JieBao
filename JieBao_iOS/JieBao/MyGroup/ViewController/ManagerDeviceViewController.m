//
//  ManagerDeviceViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/14.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//  分组设备列表管理界面

#import "ManagerDeviceViewController.h"
#import "BaseTableView.h"
#import "GroupEditCell.h"
#import "AddDeviceViewController.h"
#import "CustomDevice.h"

@interface ManagerDeviceViewController ()<UITableViewDataSource,UITableViewDelegate,GizDeviceGroupDelegate>

@property (nonatomic, strong) BaseTableView *tb;


@property (nonatomic, strong) UIView *addBgview;

/**添加按钮*/
@property (nonatomic, strong) UIButton *addBtn;

@property (nonatomic, strong) NSMutableArray<CustomDevice *> *dataSource;

@end

@implementation ManagerDeviceViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UICOLORFROMRGB(0xededed);
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tabBarController.tabBar setHidden:NO];
}

- (void)initUI
{
    [self configNavBarWithEdit:NO];
    [self.view addSubview:self.tb];
    [self.addBgview addSubview:self.addBtn];
    self.tb.tableFooterView = self.addBgview;
    self.addBgview.hidden = YES;

}

- (void)showEdit
{
    self.addBgview.hidden = NO;
    [self.tb setEditing:YES animated:YES];
    [self configNavBarWithEdit:YES];
    self.tb.tableFooterView = self.addBgview;

}

- (void)finishEdit
{
    self.addBgview.hidden = YES;
    [self.tb setEditing:NO animated:YES];
    [self configNavBarWithEdit:NO];


}

-(void)configNavBarWithEdit:(BOOL)isEdit{
    
    LHWeakSelf(self)
    ActionBlock rightAction = ^(UIButton *btn){
        if (btn.isSelected) {
            [weakself showEdit];
        }else
        {
            [weakself finishEdit];
        }
        LHLog(@"right");
    };
    
    ActionBlock leftAction = ^(UIButton *btn){
        [weakself.navigationController popViewControllerAnimated:YES];
        LHLog(@"left");
    };
    if (isEdit) {
        [self.naviBar  configNavigationBarWithAttrs:@{
                                                      kCustomNaviBarLeftActionKey:leftAction,
                                                      kCustomNaviBarLeftImgKey:@"back",
                                                      kCustomNaviBarTitleKey:@"管理分组设备",
                                                    kCustomNaviBarRightImgKey:@"queding1",
                                                kCustomNaviBarRightActionKey:rightAction
                                                      }];
    }else{
        [self.naviBar  configNavigationBarWithAttrs:@{
                                                      kCustomNaviBarLeftActionKey:leftAction,
                                                      kCustomNaviBarLeftImgKey:@"back",
                                                      kCustomNaviBarTitleKey:@"管理分组设备",
                                                      kCustomNaviBarRightImgKey:@"bianji",
                                                      kCustomNaviBarRightActionKey:rightAction
                                                      }];
    }
   
}

- (void)addBtnClicked
{
    AddDeviceViewController *vc = [AddDeviceViewController new];
    vc.group = self.group;
    vc.callback = ^(CustomDeviceGroup *obj) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self finishEdit];
            self.dataSource = obj.devs;
            [self.tb reloadData];
        });
        
    };
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - tableView Delegate|DataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"GroupEditCell";
    GroupEditCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[GroupEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.dataDic = self.dataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath

{
    return UITableViewCellEditingStyleDelete;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle==UITableViewCellEditingStyleDelete) {
        [NetworkHelper sendRequest:@{@"dids":@[self.dataSource[indexPath.row].did]} Method:@"DELETE" Path:[NSString stringWithFormat:@"https://api.gizwits.com/app/group/%@/devices",self.group.gid] callback:^(NSData *data, NSError *error) {
            if (error) {
                return ;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.dataSource removeObject:self.dataSource[indexPath.row]];
                [self.tb reloadData];
            });
        }];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CurrentDeviceSize(50);
}


#pragma mark - lazy init 
- (BaseTableView *)tb
{
    if (!_tb) {
        _tb = [[BaseTableView alloc] initWithFrame:CGRectMake(0, CurrentDeviceSize(40 + LL_StatusBarAndNavigationBarHeight), LL_ScreenWidth, LL_ScreenHeight) style:UITableViewStylePlain];
        _tb.backgroundColor = [UIColor clearColor];
        _tb.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tb.scrollEnabled = NO;
        _tb.dataSource = self;
        _tb.delegate = self;
        _tb.tableFooterView = [UIView new];
    }
    return _tb;
}

- (UIButton *)addBtn
{
    if (!_addBtn) {
        _addBtn = [UIButton new];
        [_addBtn setBackgroundImage:[UIImage imageNamed:@"tianjia3"] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        _addBtn.frame = CGRectMake((LL_ScreenWidth - 40)*0.5,20, 40, 40);
        _addBtn.hidden = NO;
    }
    return _addBtn;
}


- (UIView *)addBgview
{
    if (!_addBgview) {
        _addBgview = [UIView new];
        _addBgview.backgroundColor = [UIColor clearColor];
        _addBgview.frame = CGRectMake(0, 0,LL_ScreenWidth, 80);
    }
    return _addBgview;
}

- (NSMutableArray<CustomDevice *> *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (void)setGroup:(CustomDeviceGroup *)group
{
    _group = group;
    self.dataSource = group.devs;
    [self.tb reloadData];
}
@end
