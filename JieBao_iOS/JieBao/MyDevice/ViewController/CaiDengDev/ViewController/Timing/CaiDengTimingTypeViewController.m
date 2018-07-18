//
//  CaiDengTimingTypeViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/20.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "CaiDengTimingTypeViewController.h"
#import "BaseTableView.h"
#import "CaiDengTimingCell.h"
#import "CaiDengTimingAddCell.h"
#import "SchedulerFootAddView.h"
#import "TimingSettingViewController.h"
#import "DeviceSchedulerTask.h"
#import "DeviceCommonSchulder.h"


@interface CaiDengTimingTypeViewController ()<UITableViewDataSource,UITableViewDelegate,SchedulerFootAddViewDelegate,CaiDengTimingAddCellDelegate,GizDeviceSchedulerDelegate>

@property (nonatomic, strong) BaseTableView *tb;

@property (nonatomic, strong) NSMutableArray<DeviceSchedulerTask *> *dataSource;

@property (nonatomic, strong) NSMutableArray<NSString *> *nameSoure;

@property (nonatomic, strong) NSMutableArray<DeviceSchedulerTask *> *temps;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, assign) BOOL isEdit;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) NSInteger sucCount;
@end

@implementation CaiDengTimingTypeViewController

-(void)dealloc {
    [SVProgressHUD dismiss];
}

- (instancetype)init
{
    if (self = [super init]) {
        self.isEdit = NO;
        _currentIndex = 1000;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kAPPBackGround;
    [self initUI];
    [self showEdit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    @weakify(self);
    [SVProgressHUD show];
    [NetworkHelper sendRequest:nil Method:@"GET" Path:[NSString stringWithFormat:@"https://api.gizwits.com/app/common_scheduler?%@&limit=200",self.dev?[NSString stringWithFormat:@"did=%@",self.dev.did]:[NSString stringWithFormat:@"group_id=%@",self.group.gid]] callback:^(NSData *data, NSError *error) {
        [SVProgressHUD dismiss];
        if (!data || error) {
            return ;
        }
        NSArray *list =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//        if (list.count == 0) {
//            [HudHelper showStatus:@"没有查询到定时任务"];
//            return;
//        }
        @strongify(self);
        [self.dataSource removeAllObjects];
        DeviceSchedulerTask *LPStask = [DeviceSchedulerTask new];
        LPStask.taskLogo = @"dingshichengxu";
        LPStask.taskName = @"LPS程序";

        DeviceSchedulerTask *SPStask = [DeviceSchedulerTask new];
        SPStask.taskName = @"SPS程序";
        SPStask.taskLogo = @"dingshichengxu";

        [self.dataSource addObject:LPStask];
        [self.dataSource addObject:SPStask];
        
        NSString *taskName = nil;
        NSMutableArray *arr = nil;
        DeviceSchedulerTask *task = nil;
        for (int i = 0; i< list.count; i++) {
            DeviceCommonSchulder *sch = [DeviceCommonSchulder yy_modelWithJSON:list[i]];
            
//            [NetworkHelper sendRequest:nil Method:@"DELETE" Path:[NSString stringWithFormat:@"https://api.gizwits.com/app/common_scheduler/%@",sch.sid] callback:^(NSData *data, NSError *error) {
//
//            }];
            if (![taskName isEqualToString:sch.remark]) {
                arr = [NSMutableArray array];
                taskName = sch.remark;
                task = [DeviceSchedulerTask new];
                task.sches = arr;
                task.taskName = taskName;
                task.taskLogo = @"dinggshi";
                [self.nameSoure addObject:taskName];
            }
            [arr addObject:sch];
            if (arr.count == 24) {
                [self.dataSource addObject:task];
            }
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tb mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(@((self.dataSource.count + (self.isEdit && self.dataSource.count < 8 ? 0:1))*CurrentDeviceSize(44)));
            }];
            [self.tb reloadData];
        });
    }];

    
    ActionBlock leftAction = ^(UIButton *btn){
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    ActionBlock rightAction = ^(UIButton *btn){
        @strongify(self);
        [self showEdit];
    };
    [self.naviBar  configNavigationBarWithAttrs:@{
                                                  kCustomNaviBarLeftActionKey:leftAction,
                                                  kCustomNaviBarLeftImgKey:@"back",
                                                  kCustomNaviBarTitleKey:@"定时程序",
                                                  kCustomNaviBarRightImgKey:@"bianji",
                                                  kCustomNaviBarRightActionKey:rightAction
                                                  }];
}

- (void)initUI
{
    [self.bgView addSubview:self.tb];
    [self.bgView addSubview:self.confirmBtn];
    [self makeContraints];
}

- (void)makeContraints
{
    LHWeakSelf(self)
    [self.tb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.size.equalTo(@(8*CurrentDeviceSize(44)));
    }];

    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view);
        make.left.equalTo(@(CurrentDeviceSize(40)));
        make.right.equalTo(weakself.view.mas_right).offset(-CurrentDeviceSize(40));
        make.top.equalTo(weakself.tb.mas_bottom).offset(CurrentDeviceSize(40));
    }];
}

- (void)showEdit
{
    self.isEdit = !self.isEdit;
    [self.tb mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@((self.dataSource.count + (self.isEdit && self.dataSource.count < 8 ? 0:1))*CurrentDeviceSize(44)));
    }];
    self.confirmBtn.hidden = !self.isEdit;
    [self.tb reloadData];
}



#pragma mark - tableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellId = @"CaiDengTimingCell";
        CaiDengTimingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[CaiDengTimingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.dataDic = self.dataSource[indexPath.row];
        cell.isEdit = self.isEdit;
        if (indexPath.row == self.currentIndex) {
            if (self.isEdit) {
                [cell setSelectedWithStutas:YES];
            }else
            {
                [cell setSelectedWithStutas:NO];
            }
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else
    {
        static NSString *cellId = @"CaiDengTimingAddCell";
        CaiDengTimingAddCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[CaiDengTimingAddCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? self.dataSource.count : (self.isEdit && self.dataSource.count < 8 ? 0:1);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CurrentDeviceSize(44);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (self.currentIndex != indexPath.row) {
        UITableViewCell *selsectedCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:indexPath.section]];
        if ([(CaiDengTimingCell *)selsectedCell getSelected]) {
             [(CaiDengTimingCell *)selsectedCell setSelected];
        }
        self.currentIndex = indexPath.row;
    }
    
    if (self.isEdit) {
        if (![cell isKindOfClass:[CaiDengTimingCell class]]) {
            return;
        }
        [(CaiDengTimingCell *)cell setSelected];
        [self.temps removeAllObjects];
        [self.temps addObject:self.dataSource[self.currentIndex]];
    }else{
        UIViewController *vc = [self loadViewControllerWithStoryboardName:@"Timing" withViewControllerName:@"NewTimingViewController"];
        [self.navigationController pushViewController:vc animated:YES];
        
//        TimingSettingViewController *vc = [TimingSettingViewController new];
//        vc.dev = self.dev;
//        vc.group = self.group;
//        vc.nameSoure = self.nameSoure;
//        if(indexPath.row == 0)
//        {
//            vc.type = @"LPS";
//        }
//        else if (indexPath.row == 1)
//        {
//            vc.type = @"SPS";
//        }
//        else
//        {
//            vc.schTask = ((CaiDengTimingCell *)cell).dataDic;
//        }
//        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - btnAction
- (void)addSchBtnClicked
{
    if (self.dataSource.count >= 8) {
        return;
    }
    TimingSettingViewController *vc = [TimingSettingViewController new];
    vc.dev = self.dev;
    vc.group = self.group;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark setter & getter
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

- (void)confirmBtnClicked
{
    //    self.count = 0;
    //    self.sucCount = 0;
    //    if (self.currentIndex == 0) {
    //
    //    }else if(self.currentIndex == 1){
    //        [SVProgressHUD show];
    //        for (int i = 0; i < 24; i++) {
    //            NSMutableDictionary *body = [NSMutableDictionary dictionaryWithDictionary:@{@"attrs":@{@"color_white":@(((NSString *)kSPS[0][i]).integerValue)},@"date":[[NSDate dateWithTimeInterval:24*60*60 sinceDate:[NSDate date]] formattedDateWithFormat:@"yyyy-MM-dd"],@"time":[NSString stringWithFormat:@"%02d:00",i],@"repeat":@"none",@"enabled":@(NO),@"remark":@"SPS"}];
    //            if (self.dev) {
    //                [body setObject:self.dev.did forKey:@"did"];
    //            }else
    //            {
    //                [body setObject:self.group.gid forKey:@"group_id"];
    //            }
    //
    //            [NetworkHelper sendRequest:body Method:@"POST" Path:@"https://api.gizwits.com/app/common_scheduler" callback:^(NSData *data, NSError *error) {
    //                @synchronized(self)
    //                {
    //                    self.count++;
    //                }
    //                if (self.count == 24) {
    //                    [HudHelper dismiss];
    //                }
    //
    //                if (!data || error) {
    //                    LHLog(@"创建定时失败");
    //                    return ;
    //                }
    //                NSDictionary *jsonObj =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    //
    //                if (!jsonObj) {
    //                    return;
    //                }
    //
    //                @synchronized(self)
    //                {
    //                    self.sucCount++;
    //                }
    //                if (self.count == 24) {
    //                    if (self.sucCount == 24) {
    //                        [HudHelper showSuccessWithStatus:@"设置成功"];
    //                        dispatch_async(dispatch_get_main_queue(), ^{
    //                            [self.navigationController popViewControllerAnimated:YES];
    //                        });
    //                    }else
    //                    {
    //                        [HudHelper showErrorWithStatus:@"设置失败"];
    //                    }
    //                    self.sucCount = 0;
    //                    self.count = 0;
    //                }
    //                LHLog(@"创建定时成功%@==%@",jsonObj[@"id"],jsonObj);
    //            }];
    //        }
    //    }
    self.count = 0;
    self.sucCount = 0;
    //开启定时任务
    [SVProgressHUD show];
    DeviceSchedulerTask *schTask = self.temps.firstObject;
    
    if (schTask.sches.count == 0) {
        [SVProgressHUD dismiss];
        [HudHelper showErrorWithStatus:@"设置失败"];
        return;
    }
    for (DeviceCommonSchulder *sch in schTask.sches) {
        sch.enabled = YES;
//        NSDictionary *dic = [sch yy_modelToJSONObject];
//        NSMutableDictionary *body = [NSMutableDictionary dictionaryWithDictionary:dic];
//        [body removeObjectForKey:@"id"];

        /*
         {
         "attrs": {
         "color_red" : 10
         },
         "time": "11:00",
         "repeat": "none",
         "enabled": 1,
         "remark": "string",
         "date":"2018-07-13"
         }
         */
        NSMutableDictionary *body = [NSMutableDictionary dictionary];
        [body setObject:sch.sid forKey:@"id"];
        [body setObject:sch.attrs forKey:@"attrs"];
        [body setObject:sch.time forKey:@"time"];
        [body setObject:sch.repeat forKey:@"repeat"];
        [body setObject:@(1) forKey:@"enabled"];
        [body setObject:sch.date forKey:@"date"];
        [body setObject:sch.remark forKey:@"remark"];

        @weakify(self);
        [NetworkHelper sendRequest:body Method:@"PUT" Path:[NSString stringWithFormat:@"https://api.gizwits.com/app/common_scheduler/%@",sch.sid] callback:^(NSData *data, NSError *error) {
            @strongify(self);
//            @synchronized(self)
//            {
//                self.count++;
//            }
            self.count++;
            if (self.count == 24) {
                [HudHelper dismiss];
            }
            
            if (data != nil) {
                NSDictionary *tempDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",tempDic);
            }
            
            if (!data || error) {
                return ;
            }
            
//            @synchronized(self)
//            {
//                self.sucCount++;
//            }
            self.sucCount++;
            if (self.count == 24) {
                if (self.sucCount == 24) {
                    [HudHelper showSuccessWithStatus:@"设置成功"];
                }else
                {
                    [HudHelper showErrorWithStatus:@"设置失败"];
                }
                self.sucCount = 0;
                self.count = 0;
            }
        }];
    }
}

- (UIButton *)confirmBtn
{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton new];
        [_confirmBtn addTarget:self action:@selector(confirmBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_confirmBtn setTitle:@"确认使用" forState:UIControlStateNormal];
        _confirmBtn.layer.masksToBounds = YES;
        _confirmBtn.layer.cornerRadius = CurrentDeviceSize(5);
        [_confirmBtn setBackgroundImage:[UIImage imageNamed:@"btnBg"] forState:UIControlStateNormal];
        [_confirmBtn.titleLabel setTextColor:[UIColor whiteColor]];
    }
    return _confirmBtn;
}

- (NSMutableArray<DeviceSchedulerTask *> *)dataSource
{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (NSMutableArray<DeviceSchedulerTask *> *)temps
{
    if (!_temps) {
        _temps = [NSMutableArray array];
    }
    return _temps;
}

- (NSMutableArray<NSString *> *)nameSoure
{
    if (!_nameSoure) {
        _nameSoure = [NSMutableArray array];
    }
    return _nameSoure;
}
@end
