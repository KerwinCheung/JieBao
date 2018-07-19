//
//  CaiDengTimingTypeViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/20.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//  定时器列表界面

#import "CaiDengTimingTypeViewController.h"
#import "BaseTableView.h"
#import "CaiDengTimingCell.h"
#import "CaiDengTimingAddCell.h"
#import "SchedulerFootAddView.h"
#import "TimingSettingViewController.h"
#import "DeviceSchedulerTask.h"
#import "DeviceCommonSchulder.h"
#import "NewTimingViewController.h"

@interface CaiDengTimingTypeViewController ()<UITableViewDataSource,UITableViewDelegate,SchedulerFootAddViewDelegate,CaiDengTimingAddCellDelegate,GizDeviceSchedulerDelegate>

@property (nonatomic, strong) BaseTableView *tb;


@property (nonatomic, strong) NSMutableArray<NSString *> *nameSoure;

@property (nonatomic, strong) NSMutableArray<DeviceSchedulerTask *> *temps;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, assign) BOOL isEdit;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) NSInteger sucCount;

/**关闭定时器计算器*/
@property (nonatomic, assign) NSInteger closeCount;
/**选择定时器计算器*/
@property (nonatomic, assign) NSInteger closeSucCount;

/**用于保存定时组的字典*/
@property (nonatomic, strong) NSMutableDictionary *dataSourceDic;

/**当前执行中的定时任务*/
@property (nonatomic, strong) DeviceSchedulerTask *currentEnableTask;

//颜色数值数组
@property (nonatomic, strong) NSMutableArray *whiteValues;
@property (nonatomic, strong) NSMutableArray *blue1Values;
@property (nonatomic, strong) NSMutableArray *blue2Values;
@property (nonatomic, strong) NSMutableArray *greenValues;
@property (nonatomic, strong) NSMutableArray *redValues;
@property (nonatomic, strong) NSMutableArray *violetValues;


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
    [SVProgressHUD show];
    
    [self.nameSoure removeAllObjects];
    [self.dataSourceDic removeAllObjects];
    [self addDefaultTask];
    
    @weakify(self);
    [NetworkHelper sendRequest:nil Method:@"GET" Path:[NSString stringWithFormat:@"https://api.gizwits.com/app/common_scheduler?%@&limit=200",self.dev?[NSString stringWithFormat:@"did=%@",self.dev.did]:[NSString stringWithFormat:@"group_id=%@",self.group.gid]] callback:^(NSData *data, NSError *error) {
        [SVProgressHUD dismiss];
        if (!data || error) {
            return ;
        }
        NSArray *list =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        @strongify(self);

        for (int i = 0; i< list.count; i++) {
            DeviceCommonSchulder *sch = [DeviceCommonSchulder yy_modelWithJSON:list[i]];
            DeviceSchedulerTask *task = nil;
            
            if ([self.dataSourceDic.allKeys containsObject:sch.remark]) {
                //字典中包含此定时名字的 task
                task = [self.dataSourceDic objectForKey:sch.remark];
                NSMutableArray *marr = [NSMutableArray arrayWithArray:task.sches];
                [marr addObject:sch];
                task.sches = marr;
                
            }else{
                //字典中不包含此定时名字的 task
                NSMutableArray *marr = [NSMutableArray array];
                task = [DeviceSchedulerTask new];
                task.taskName = sch.remark;
                [marr addObject:sch];
                task.sches = marr;
                task.taskLogo = @"dingshichengxu";
                [self.dataSourceDic setObject:task forKey:task.taskName];
                
            }
        }
        
       
        for (NSInteger i = 0; i<self.dataSourceDic.allKeys.count; i++) {
            NSString *taskName = [self.dataSourceDic.allKeys objectAtIndex:i];
            DeviceSchedulerTask *task = [self.dataSourceDic objectForKey:taskName];
            [self.nameSoure addObject:task.taskName];
        }
        
        // 保证LPS程序和SPS程序排在最前面
        [self.nameSoure removeObject:@"LPS程序"];
        [self.nameSoure removeObject:@"SPS程序"];
        [self.nameSoure insertObject:@"LPS程序" atIndex:0];
        [self.nameSoure insertObject:@"SPS程序" atIndex:1];
        
        //获取执行中的定时组的序号
        for (NSInteger i =0; i<self.nameSoure.count; i++) {
            NSString *taskName = [self.nameSoure objectAtIndex:i];
            BOOL isEnable = [UtilHelper checkTaskIsEnabledWithTask:[self.dataSourceDic objectForKey:taskName]];
            if (isEnable) {
                self.currentIndex = i;
                self.currentEnableTask = [self.dataSourceDic objectForKey:taskName];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{

            [self.tb mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.equalTo(@((self.nameSoure.count + (self.isEdit && self.nameSoure.count < 8 ? 0:1))*CurrentDeviceSize(44)));
            }];
            [self.tb reloadData];
        });
    }];

    [self  configNavBar];
}

-(void)configNavBar{
    // 配置导航栏
    @weakify(self);
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



-(void)addDefaultTask{
    // 添加默认定时任务
    DeviceSchedulerTask *LPStask = [DeviceSchedulerTask new];
    LPStask.taskLogo = @"dingshichengxu";
    LPStask.taskName = @"LPS程序";
    LPStask.isDeafult = YES;
    
    DeviceSchedulerTask *SPStask = [DeviceSchedulerTask new];
    SPStask.taskName = @"SPS程序";
    SPStask.taskLogo = @"dingshichengxu";
    SPStask.isDeafult = YES;
    
    [self.dataSourceDic setObject:LPStask forKey:LPStask.taskName];
    [self.dataSourceDic setObject:SPStask forKey:SPStask.taskName];
}


- (void)showEdit
{
    self.isEdit = !self.isEdit;
    [self.tb mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(@((self.nameSoure.count + (self.isEdit && self.nameSoure.count < 8 ? 0:1))*CurrentDeviceSize(44)));
    }];
    self.confirmBtn.hidden = !self.isEdit;
    [self.tb reloadData];
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




#pragma mark - tableView Delegate | DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    return section == 0 ? self.nameSoure.count : (self.isEdit && self.nameSoure.count < 8 ? 0:1);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CurrentDeviceSize(44);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        static NSString *cellId = @"CaiDengTimingCell";
        CaiDengTimingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[CaiDengTimingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        NSString *taskName = self.nameSoure[indexPath.row];
        cell.dataDic = [self.dataSourceDic objectForKey:taskName];
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
        
        NSString *taskName = self.nameSoure[self.currentIndex];
        [self.temps addObject:[self.dataSourceDic objectForKey:taskName]];
    }else{
        
        TimingSettingViewController *vc = [TimingSettingViewController new];
        vc.dev = self.dev;
        vc.group = self.group;
        vc.nameSoure = self.nameSoure;
        if(indexPath.row == 0)
        {
            vc.type = @"LPS";
        }
        else if (indexPath.row == 1)
        {
            vc.type = @"SPS";
        }
        else
        {
            vc.schTask = ((CaiDengTimingCell *)cell).dataDic;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - btnAction
- (void)addSchBtnClicked
{
    if (self.nameSoure.count >= 8) {
        [HudHelper showErrorWithStatus:@"最多添加8个定时任务"];
        return;
    }
    TimingSettingViewController *vc = [TimingSettingViewController new];
    vc.dev = self.dev;
    vc.group = self.group;
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)confirmBtnClicked
{
    //开启定时任务
    self.count = 0;
    self.sucCount = 0;
    
    [SVProgressHUD show];
    DeviceSchedulerTask *schTask = self.temps.firstObject;
    
    if (schTask.sches.count == 0) {
        [SVProgressHUD dismiss];
        if ([schTask.taskName containsString:@"LPS"]||[schTask.taskName containsString:@"SPS"]) {
            // 如果是默认的定时程序，则去创建
            [self setDefaultTimerWithTask:schTask];
            return;
        }
        
        [HudHelper showErrorWithStatus:@"设置失败"];
        return;
    }
    for (DeviceCommonSchulder *sch in schTask.sches) {
        sch.enabled = YES;
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

            self.count++;
            if (self.count == 24) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [HudHelper dismiss];
                 });
            }
            
            if (data != nil) {
                NSDictionary *tempDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",tempDic);
            }
            
            if (!data || error) {
                return ;
            }
            self.sucCount++;
            if (self.count == 24) {
                //关闭之前的定时器
                [self closeTimer];
                if (self.sucCount == 24) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [HudHelper showSuccessWithStatus:@"设置成功"];
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                         [HudHelper showErrorWithStatus:@"开启定时器失败"];
                    });
                }
                self.sucCount = 0;
                self.count = 0;
            }
        }];
    }
}

-(void)closeTimer{
    
    if (self.currentEnableTask.sches.count == 0) {
        LHLog(@"当前执行的定时组没有定时器");
        //获取当前执行的定时任务组
        for (NSInteger i =0; i<self.nameSoure.count; i++) {
            NSString *taskName = [self.nameSoure objectAtIndex:i];
            
            BOOL isEnable = [UtilHelper checkTaskIsEnabledWithTask:[self.dataSourceDic objectForKey:taskName]];
            
            if (isEnable) {
                self.currentIndex = i;
                self.currentEnableTask = [self.dataSourceDic objectForKey:taskName];
            }
        }
        return;
    }
    
    self.closeSucCount = 0;
    self.closeCount    = 0;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD show];
    });
    
    for (DeviceCommonSchulder *sch in self.currentEnableTask.sches) {
        sch.enabled = NO;
        NSMutableDictionary *body = [NSMutableDictionary dictionary];
        [body setObject:sch.sid forKey:@"id"];
        [body setObject:sch.attrs forKey:@"attrs"];
        [body setObject:sch.time forKey:@"time"];
        [body setObject:sch.repeat forKey:@"repeat"];
        [body setObject:@(0) forKey:@"enabled"];
        [body setObject:sch.date forKey:@"date"];
        [body setObject:sch.remark forKey:@"remark"];
        
        @weakify(self);
        [NetworkHelper sendRequest:body Method:@"PUT" Path:[NSString stringWithFormat:@"https://api.gizwits.com/app/common_scheduler/%@",sch.sid] callback:^(NSData *data, NSError *error) {
            @strongify(self);
            self.closeCount++;
            if (self.closeCount == 24) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [HudHelper dismiss];
                });
            }
            
            if (data != nil) {
                NSDictionary *tempDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",tempDic);
            }
            
            if (!data || error) {
                return ;
            }
            self.closeSucCount++;
            if (self.closeSucCount == 24) {
                //获取当前执行的定时任务组
                for (NSInteger i =0; i<self.nameSoure.count; i++) {
                    NSString *taskName = [self.nameSoure objectAtIndex:i];
                    
                    BOOL isEnable = [UtilHelper checkTaskIsEnabledWithTask:[self.dataSourceDic objectForKey:taskName]];
                    
                    if (isEnable) {
                        self.currentIndex = i;
                        self.currentEnableTask = [self.dataSourceDic objectForKey:taskName];
                    }
                }
                [self setCurrentTimerControlInstruction];
                
                if (self.closeSucCount == 24) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [HudHelper showSuccessWithStatus:@"设置成功"];
//                    });
                }else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [HudHelper showErrorWithStatus:@"关闭之前定时器失败"];
                    });
                }
                self.closeCount = 0;
                self.closeSucCount = 0;
            }
        }];
    }
}

-(void)setCurrentTimerControlInstruction{
// 下发当前时间的定时器控制指令
    if (self.currentEnableTask.sches.count == 0) {
        return;
    }
    NSDictionary *controlDic = [NSDictionary dictionary];
    @weakify(controlDic);
    
        [self.currentEnableTask.sches enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(DeviceCommonSchulder * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *nowHour = [[NSDate date] formattedDateWithFormat:@"HH"];
            NSArray *timeArray = [obj.time componentsSeparatedByString:@":"];
            @strongify(controlDic);
            if ([timeArray.firstObject isEqualToString:nowHour]) {
                controlDic = @{@"mode":@6,
                               @"Timer":@YES,
                               @"color_white":@([[obj.attrs objectForKey:@"color_white"] integerValue]),
                               @"color_blue1":@([[obj.attrs objectForKey:@"color_blue1"] integerValue]),
                               @"color_blue2":@([[obj.attrs objectForKey:@"color_blue2"] integerValue]),
                               @"color_green":@([[obj.attrs objectForKey:@"color_green"] integerValue]),
                               @"color_red":@([[obj.attrs objectForKey:@"color_red"] integerValue]),
                               @"volor_violet":@([[obj.attrs objectForKey:@"volor_violet"] integerValue])
                               };
                *stop = YES;
                if (self.dev) {
                    [self.dev write:controlDic withSN:999];
                }else{
                    [self sendGroupControlWith:controlDic];
                }
            }
        }];
}

- (void)sendGroupControlWith:(NSDictionary *)dic {
        NSDictionary *body = @{@"attrs":dic};
        [NetworkHelper sendRequest:body Method:@"POST" Path:[NSString stringWithFormat:@"https://api.gizwits.com/app/group/%@/control",self.group.gid] callback:^(NSData *data, NSError *error) {
            if (!data || error) {
//                [HudHelper showErrorWithStatus:@"设置失败"];
                return ;
            }
//            [HudHelper showSuccessWithStatus:@"设置成功"];
        }];
}

-(void)setDefaultTimerWithTask:(DeviceSchedulerTask *)task{
    // 定时器的命名规则为：名称_时间戳
    NSString *taskName = [NSString stringWithFormat:@"%@_%@",task,[UtilHelper getTimeStampStr]];
    
    if ([taskName containsString:@"LPS"]) {
        [self setUpTempValuesWithArrays:kLPS];
    }else{
        [self setUpTempValuesWithArrays:kSPS];
    }
    
    
    [SVProgressHUD show];
    self.count = 0;
    self.sucCount = 0;
    @weakify(self);
    
    NSString *dateStr = [UtilHelper stringFromDate:[NSDate date]];
    
    for (int i = 0; i < 24; i++)
    {
        NSString *originTimerStr = [NSString stringWithFormat:@"%02d:00",i];
        NSString *str = [NSString stringWithFormat:@"%@ %@",dateStr,originTimerStr];
        NSDate *setDate = [UtilHelper dateFromString:str];
        NSString *utcTimerStr = [setDate formattedDateWithFormat:@"HH:mm"];
        
        NSMutableDictionary *body = [NSMutableDictionary
                                     dictionaryWithDictionary:@{@"attrs":@{@"color_white":@([self.whiteValues[i] integerValue]),
                                                                           @"color_blue1":@([self.blue1Values[i] integerValue]),
                                                                           @"color_blue2":@([self.blue2Values[i] integerValue]),
                                                                           @"color_green":@([self.greenValues[i] integerValue]),
                                                                           @"color_red":@([self.redValues[i] integerValue]),
                                                                           @"volor_violet":@([self.violetValues[i] integerValue]),
                                                                           @"Timer" :@YES
                                                                           },
                                                                @"time":utcTimerStr,
                                                                @"repeat":@"mon,tue,wed,thu,fri,sat,sun",
                                                                @"enabled":@(0),
                                                                @"remark":taskName}];
        if (self.dev) {
            [body setObject:self.dev.did forKey:@"did"];
        }else
        {
            [body setObject:self.group.gid forKey:@"group_id"];
        }
        [NetworkHelper sendRequest:body Method:@"POST" Path:@"https://api.gizwits.com/app/common_scheduler" callback:^(NSData *data, NSError *error) {
            @strongify(self);
            
            if (data != nil) {
                NSDictionary *tempDic =[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                NSLog(@"%@",tempDic);
            }
            self.count++;
            NSLog(@"发送定时任务%zd次",self.count);
            if (self.count == 24) {
                [HudHelper dismiss];
            }
            
//            if (!data || error) {
//                LHLog(@"创建定时失败");
//                return ;
//            }
            NSDictionary *jsonObj =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
//            if (!jsonObj) {
//                return;
//            }
            
            self.sucCount++;
            if (self.count == 24) {
                
                //关闭之前的定时器
                [self closeTimer];
                if (self.sucCount == 24) {
                    [HudHelper showSuccessWithStatus:@"设置成功"];
                    
                }else
                {
                    [HudHelper showErrorWithStatus:@"设置失败"];
                }
                self.sucCount = 0;
                self.count = 0;
            }
            LHLog(@"创建定时成功%@==%@",jsonObj[@"id"],jsonObj);
        }];
    }
}

- (void)setUpTempValuesWithArrays:(NSArray *)array {
    self.whiteValues = array[0];
    self.blue1Values = array[1];
    self.blue2Values = array[2];
    self.greenValues = array[3];
    self.redValues = array[4];
    self.violetValues = array[5];
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

-(NSMutableDictionary *)dataSourceDic{
    if (!_dataSourceDic) {
        _dataSourceDic = [NSMutableDictionary dictionary];
    }
    return _dataSourceDic;
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

#pragma mark - 颜色值数组
- (NSMutableArray *)whiteValues {
    //白
    if (!_whiteValues) {
        _whiteValues = [NSMutableArray array];
    }
    return _whiteValues;
}

- (NSMutableArray *)blue1Values {
    //浅蓝
    if (!_blue1Values) {
        _blue1Values = [NSMutableArray array];
    }
    return _blue1Values;
}

- (NSMutableArray *)blue2Values {
    //蓝
    if (!_blue2Values) {
        _blue2Values = [NSMutableArray array];
    }
    return _blue2Values;
}

- (NSMutableArray *)greenValues {
    //绿
    if (!_greenValues) {
        _greenValues = [NSMutableArray array];
    }
    return _greenValues;
}

- (NSMutableArray *)redValues {
    //红
    if (!_redValues) {
        _redValues = [NSMutableArray array];
    }
    return _redValues;
}

- (NSMutableArray *)violetValues {
    //紫
    if (!_violetValues) {
        _violetValues = [NSMutableArray array];
    }
    return _violetValues;
}

@end
