//
//  TimingSettingViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/5/9.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "TimingSettingViewController.h"
#import "LightControlView.h"
#import "TimingChartView.h"
#import "PreinstallSelectView.h"

@interface TimingSettingViewController ()<LightControlViewDelegate,PreinstallSelectViewDelegate,TimingChartViewDelegate>

@property (nonatomic, strong) UITextField *timingTextView;

@property (nonatomic, strong) UIImageView *sepImgView;

@property (nonatomic, strong) UILabel *subLb;

@property (nonatomic, strong) LightControlView *whiteLcView;

@property (nonatomic, strong) LightControlView *sapphireBlueLcView;

@property (nonatomic, strong) LightControlView *blueLcView;

@property (nonatomic, strong) LightControlView *greenLcView;

@property (nonatomic, strong) LightControlView *redLcView;

@property (nonatomic, strong) LightControlView *puepleLcView;

@property (nonatomic, strong) TimingChartView *lineChartView;

@property (nonatomic, strong) UIButton *spsBtn;

@property (nonatomic, strong) UIButton *saveBtn;

@property (nonatomic, strong) UIButton *deleteBtn;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) PreinstallSelectView *selectView;
@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) NSDictionary *dic;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) LightControlView *currentSelectView;

@property (nonatomic, strong) NSMutableArray *tempArr;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) NSInteger sucCount;

@property (nonatomic, assign) int yusheSelected;


//颜色数值数组
@property (nonatomic, strong) NSMutableArray *whiteValues;
@property (nonatomic, strong) NSMutableArray *blue1Values;
@property (nonatomic, strong) NSMutableArray *blue2Values;
@property (nonatomic, strong) NSMutableArray *greenValues;
@property (nonatomic, strong) NSMutableArray *redValues;
@property (nonatomic, strong) NSMutableArray *violetValues;

//预设数值数组
@property (nonatomic, strong) NSMutableArray <NSNumber *> *lpsDemo;
@property (nonatomic, strong) NSMutableArray <NSNumber *> *spsDemo;

@end

@implementation TimingSettingViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.yusheSelected = -100;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dic = @{@0:@"color_white",@1:@"color_blue1",@2:@"color_blue2",@3:@"color_green",@4:@"color_red",@5:@"volor_violet"};
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleDeviceOrientationDidChange:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationToPortrait:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(willEnterForegroundNoti:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [self configInitialValues];
    self.view.backgroundColor = UICOLORFROMRGB(0xf0f0f0);
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.naviBar.hidden = YES;
    //首先设置UIInterfaceOrientationUnknown欺骗系统，避免可能出现直接设置无效的情况
    NSNumber *orientationUnknown = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
    [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
    
    NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.naviBar.hidden = NO;
    NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (void)handleDeviceOrientationDidChange:(UIInterfaceOrientation)interfaceOrientation
{
    if ([UIDevice currentDevice].orientation == UIInterfaceOrientationLandscapeLeft) {
        LHLog(@"%f,%f",LL_ScreenWidth,LL_ScreenHeight);
        [self initUI];
        if (self.currentSelectView) {
            self.currentSelectView.isClicked = YES;
        }
    }
}

- (void)initUI
{
    [self.view addSubview:self.timingTextView];
    [self.view addSubview:self.sepImgView];
    [self.view addSubview:self.subLb];
    [self.view addSubview:self.whiteLcView];
    [self.view addSubview:self.sapphireBlueLcView];
    [self.view addSubview:self.blueLcView];
    [self.view addSubview:self.greenLcView];
    [self.view addSubview:self.redLcView];
    [self.view addSubview:self.puepleLcView];
    [self.view addSubview:self.lineChartView];
    [self.view addSubview:self.spsBtn];
    [self.view addSubview:self.saveBtn];
    [self.view addSubview:self.deleteBtn];
    [self.view addSubview:self.closeBtn];
    [self addBlackView];
    [self makeContraints];
}

- (void)makeContraints
{
    LHWeakSelf(self)
    [self.subLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.top.equalTo(@(CurrentDeviceSize(20)));
        make.width.lessThanOrEqualTo(@300);
    }];
    
    [self.whiteLcView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(LL_ScreenWidth/17), CurrentDeviceSize(20)));
        make.top.equalTo(weakself.subLb.mas_bottom);
        make.left.equalTo(@(LL_ScreenWidth/17));
    }];
    
    [self.sapphireBlueLcView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakself.whiteLcView);
        make.top.equalTo(weakself.whiteLcView);
        make.left.equalTo(weakself.whiteLcView.mas_right);
    }];
    
    [self.blueLcView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakself.whiteLcView);
        make.top.equalTo(weakself.whiteLcView);
        make.left.equalTo(weakself.sapphireBlueLcView.mas_right);
    }];
    
    [self.greenLcView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakself.whiteLcView);
        make.top.equalTo(weakself.whiteLcView);
        make.left.equalTo(weakself.blueLcView.mas_right);
    }];
    
    [self.redLcView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakself.whiteLcView);
        make.top.equalTo(weakself.whiteLcView);
        make.left.equalTo(weakself.greenLcView.mas_right);
    }];
    
    [self.puepleLcView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(weakself.whiteLcView);
        make.top.equalTo(weakself.whiteLcView);
        make.left.equalTo(weakself.redLcView.mas_right);
    }];
    
    [self.lineChartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(10)));
        make.top.equalTo(weakself.whiteLcView.mas_bottom).offset(CurrentDeviceSize(10));
        make.bottom.equalTo(weakself.view.mas_bottom).offset(-CurrentDeviceSize(10));
        make.right.equalTo(weakself.spsBtn.mas_left).offset(-CurrentDeviceSize(10));
    }];
    
    [self.spsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.view.mas_right).offset(-CurrentDeviceSize(10));
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(2.5*LL_ScreenHeight/18), CurrentDeviceSize(LL_ScreenHeight/18)));
        make.bottom.equalTo(weakself.saveBtn.mas_top).offset(-CurrentDeviceSize(LL_ScreenHeight/18));
    }];
    
    [self.saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.spsBtn);
        make.size.equalTo(weakself.spsBtn);;
        make.bottom.equalTo(weakself.deleteBtn.mas_top).offset(-CurrentDeviceSize(LL_ScreenHeight/18));
    }];
    
    
    [self.deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.spsBtn);
        make.size.equalTo(weakself.spsBtn);;
        make.bottom.equalTo(weakself.view.mas_bottom).offset(-CurrentDeviceSize(10));
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.equalTo(@0);
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(30), CurrentDeviceSize(30)));
    }];
    
    [self.timingTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.spsBtn);
        make.bottom.equalTo(weakself.spsBtn.mas_top).offset(-CurrentDeviceSize(40));
        make.width.equalTo(@(CurrentDeviceSize(60)));
    }];
    
    [self.sepImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(weakself.timingTextView);
        make.top.equalTo(weakself.timingTextView.mas_bottom);
        make.height.equalTo(@(CurrentDeviceSize(1)));
    }];
    
    [self.blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
    }];
    
    [self.view addSubview:self.selectView];
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakself.view);
        make.size.mas_offset(CGSizeMake(LL_ScreenWidth/2, CurrentDeviceSize(CurrentDeviceSize(44*2+30))));
    }];
}

-(void)addBlackView{
    UIView *blackView = [[UIView alloc] init];
    blackView.backgroundColor = [UIColor blackColor];
    blackView.alpha = 0.2;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked:)];
    [blackView addGestureRecognizer:tap];
    blackView.hidden = YES;
    self.blackView = blackView;
    [self.view addSubview:blackView];
}

-(void)tapClicked:(UIGestureRecognizer *)tap{
    self.selectView.hidden = YES;
    self.blackView.hidden = YES;
    
}

#pragma mark - 配置初始值
-(void)configInitialValues{
    // 配置颜色数组初始值
    if (self.schTask.sches.count == 0) {
        //新增
        if ([_type isEqualToString:@"SPS"]||[_type isEqualToString:@"LPS"]) {
            //默认程序点击进来
            self.deleteBtn.hidden = YES;
            self.spsBtn.hidden = YES;
            self.saveBtn.hidden = YES;
            
        }else{
            for (NSInteger i = 0; i< 24; i++) {
                [self.whiteValues addObject:@50];
                [self.blue1Values addObject:@50];
                [self.blue2Values addObject:@50];
                [self.greenValues addObject:@50];
                [self.redValues addObject:@50];
                [self.violetValues addObject:@50];
            }
        }
        
        
        
    }else{
        //编辑
        
        if ([_type isEqualToString:@"SPS"]||[_type isEqualToString:@"LPS"]) {
            //默认程序点击进来
            self.deleteBtn.hidden = YES;
            self.spsBtn.hidden = YES;
            self.saveBtn.hidden = YES;
        }
        
        NSString *dateStr = [UtilHelper stringFromDate:[NSDate date]];
        
        self.whiteValues = [NSMutableArray array];
        self.blue1Values = [NSMutableArray array];
        self.blue2Values = [NSMutableArray array];
        self.greenValues = [NSMutableArray array];
        self.redValues   = [NSMutableArray array];
        self.violetValues = [NSMutableArray array];
        
        for (NSInteger i = 0; i < 24; i++) {
            if (self.schTask.sches.count > i) {
                
                NSString *originTimerStr = [NSString stringWithFormat:@"%02ld:00",(long)i];
                NSString *str = [NSString stringWithFormat:@"%@ %@",dateStr,originTimerStr];
                NSDate *setDate = [UtilHelper dateFromString:str];
                NSString *utcTimerStr = [setDate formattedDateWithFormat:@"HH:mm"];
               
                
                for (DeviceCommonSchulder *tempTimer in self.schTask.sches) {
                    if ([tempTimer.time isEqualToString:utcTimerStr]) {
                        NSNumber *color_white =  [tempTimer.attrs objectForKey:@"color_white"];
                        NSNumber *color_blue1 =    [tempTimer.attrs objectForKey:@"color_blue1"];
                        NSNumber *color_blue2 =   [tempTimer.attrs objectForKey:@"color_blue2"];
                        NSNumber *color_green =   [tempTimer.attrs objectForKey:@"color_green"];
                        NSNumber *color_red =   [tempTimer.attrs objectForKey:@"color_red"];
                        NSNumber *volor_violet =   [tempTimer.attrs objectForKey:@"volor_violet"];
                        
                        [self.whiteValues addObject:color_white];
                        [self.blue1Values addObject:color_blue1];
                        [self.blue2Values addObject:color_blue2];
                        [self.greenValues addObject:color_green];
                        [self.redValues addObject:color_red];
                        [self.violetValues addObject:volor_violet];
                        break;
                    }
                }

            }else{
                [self.whiteValues addObject:@50];
                [self.blue1Values addObject:@50];
                [self.blue2Values addObject:@50];
                [self.greenValues addObject:@50];
                [self.redValues addObject:@50];
                [self.violetValues addObject:@50];
            }
        }
        
    }
    
    
    //设置定时名称
    NSArray *taskNameArr = [self.schTask.taskName componentsSeparatedByString:@"_"];
    self.timingTextView.text = taskNameArr.firstObject;
    
    [self.lineChartView setChartSchValues:self.whiteValues];
    
    [self.lineChartView setSelectedIndex:0];
    self.currentIndex = 0;
    self.currentSelectView = self.whiteLcView;
}


#pragma mark - buttonAction
- (void)spsBtnClicked
{
    self.blackView.hidden = NO;
    self.selectView.hidden = NO;
}

#pragma mark - 载入预设值
- (void)lpsSelected
{
    [self.lineChartView setChartSchValues:kLPS[self.currentIndex]];
}

- (void)spsSelected
{
    [self.lineChartView setChartSchValues:kSPS[self.currentIndex]];
}

- (void)growthSelected
{
    [self.lineChartView setChartSchValues:kGrowth[self.currentIndex]];
}

- (void)reefAquariumSelected
{
    [self.lineChartView setChartSchValues:kReef[self.currentIndex]];
}

#pragma mark - 保存按钮
- (void)saveBtnClicked
{
    if ([self.nameSoure containsObject:self.timingTextView.text]) {
        [HudHelper showErrorWithStatus:@"请修改定时任务名字"];
        return;
    }
    
    [self getValuesWhithSelectedIndex];

    // 定时器的命名规则为：名称_时间戳
    NSString *taskName = [NSString stringWithFormat:@"%@_%@",self.timingTextView.text,[UtilHelper getTimeStampStr]];
    
    
    [SVProgressHUD show];
    self.count = 0;
    self.sucCount = 0;
    @weakify(self);
    NSString *dateStr = [UtilHelper stringFromDate:[NSDate date]];

    for (int i = 0; i < 24; i++)
    {
        //@"date":[[NSDate dateWithTimeInterval:24*60*60 sinceDate:[NSDate date]] formattedDateWithFormat:@"yyyy-MM-dd"],
        //将时间转化成UTC
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
            
            if (!data || error) {
                LHLog(@"创建定时失败");
                return ;
            }
            NSDictionary *jsonObj =  [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            if (!jsonObj) {
                return;
            }
            
            @synchronized(self)
            {
                self.sucCount++;
            }
            if (self.count == 24) {
                if (self.sucCount == 24) {
                    [HudHelper showSuccessWithStatus:@"设置成功"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
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



#pragma mark 删除按钮
- (void)deleteBtnClicked
{
    if (self.schTask.sches.count == 0) {
        return;
    }
    
    [SVProgressHUD show];
    self.count = 0;
    self.sucCount = 0;
    for (int i=0; i<self.schTask.sches.count; i++) {
        [NetworkHelper sendRequest:nil Method:@"DELETE" Path:[NSString stringWithFormat:@"https://api.gizwits.com/app/common_scheduler/%@",self.schTask.sches[i].sid] callback:^(NSData *data, NSError *error) {
            @synchronized(self)
            {
                self.count++;
            }
            if (self.count == 24) {
                [HudHelper dismiss];
            }
            if (!data || error) {
                LHLog(@"删除定时失败");
                return ;
            }
            @synchronized(self)
            {
                self.sucCount++;
            }
            if (self.count == 24) {
                if (self.sucCount == 24) {
                    [HudHelper showSuccessWithStatus:@"删除成功"];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                }else{
                    [HudHelper showErrorWithStatus:@"删除失败"];
                }
                self.sucCount = 0;
                self.count = 0;
            }
            LHLog(@"删除定时成功");
        }];
    }
}

#pragma mark 右上角关闭按钮
- (void)closeBtnClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 上方颜色选择按钮回调
- (void)colorBlockClicked:(id)view
{
    if (self.currentSelectView) {
        self.currentSelectView.isClicked = NO;
    }
    
    [self getValuesWhithSelectedIndex];
    
    if ([view isEqual:self.whiteLcView])
    {
        [self.lineChartView setSelectedIndex:0];
        self.currentIndex = 0;
        self.currentSelectView = self.whiteLcView;
        [self.lineChartView setChartSchValues:self.whiteValues];
    }
    else if ([view isEqual:self.sapphireBlueLcView])
    {
        [self.lineChartView setSelectedIndex:1];
        self.currentIndex = 1;
        self.currentSelectView = self.sapphireBlueLcView;
        [self.lineChartView setChartSchValues:self.blue1Values];
    }
    else if ([view isEqual:self.blueLcView])
    {
        [self.lineChartView setSelectedIndex:2];
        self.currentIndex = 2;
        self.currentSelectView = self.blueLcView;
        [self.lineChartView setChartSchValues:self.blue2Values];
    }
    else if ([view isEqual:self.greenLcView])
    {
        [self.lineChartView setSelectedIndex:3];
        self.currentIndex = 3;
        self.currentSelectView = self.greenLcView;
        [self.lineChartView setChartSchValues:self.greenValues];
    }
    else if ([view isEqual:self.redLcView])
    {
        [self.lineChartView setSelectedIndex:4];
        self.currentIndex = 4;
        self.currentSelectView = self.redLcView;
        [self.lineChartView setChartSchValues:self.redValues];
    }
    else if ([view isEqual:self.puepleLcView])
    {
        [self.lineChartView setSelectedIndex:5];
        self.currentIndex = 5;
        self.currentSelectView = self.puepleLcView;
        [self.lineChartView setChartSchValues:self.violetValues];
    }
}

- (void)getValuesWhithSelectedIndex {
    switch (self.currentIndex) {
        case 0:
        {
            self.whiteValues = [NSMutableArray arrayWithArray:[self.lineChartView getChartValues]];
        }
            break;
        case 1:
        {
            self.blue1Values = [NSMutableArray arrayWithArray:[self.lineChartView getChartValues]];
        }
            break;
        case 2:
        {
            self.blue2Values = [NSMutableArray arrayWithArray:[self.lineChartView getChartValues]];
        }
            break;
        case 3:
        {
            self.greenValues = [NSMutableArray arrayWithArray:[self.lineChartView getChartValues]];
        }
            break;
        case 4:
        {
            self.redValues = [NSMutableArray arrayWithArray:[self.lineChartView getChartValues]];
        }
            break;
        case 5:
        {
            self.violetValues = [NSMutableArray arrayWithArray:[self.lineChartView getChartValues]];
        }
            break;
        default:
            break;
    }
}

#pragma mark - PreinstallSelectView Delegate
- (void)selectIndex:(NSInteger)index
{
    self.yusheSelected = (int)index;
    if (0 == index)
    {
        [self spsSelected];
        [self setupTempValuesWithArrays:kSPS];
    }
    else if (1 == index)
    {
        [self lpsSelected];
        [self setupTempValuesWithArrays:kLPS];
    }
    else if (2 == index)
    {
        [self growthSelected];
        [self setupTempValuesWithArrays:kGrowth];
    }
    else if (3 == index)
    {
        [self reefAquariumSelected];
        [self setupTempValuesWithArrays:kReef];
    }
    self.blackView.hidden = YES;
    self.selectView.hidden = YES;
}

- (void)setupTempValuesWithArrays:(NSArray *)array {
    self.whiteValues = array[0];
    self.blue1Values = array[1];
    self.blue2Values = array[2];
    self.greenValues = array[3];
    self.redValues = array[4];
    self.violetValues = array[5];
}

- (void)timingChartViewValueChange:(NSInteger)value
{
    self.currentSelectView.value = value;
}


#pragma mark - notifacation
- (void)orientationToPortrait:(UIInterfaceOrientation)orientation {
    
    NSNumber *orientationUnknown = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
    [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
    
    NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}

-(void)willEnterForegroundNoti:(NSNotification *)noti{
    
    // 设置屏幕为横屏
    NSNumber *orientationUnknown = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
    [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
    
    NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}


#pragma mark - setter & getter
- (UITextField *)timingTextView
{
    if (!_timingTextView) {
        _timingTextView = [UITextField new];
        _timingTextView.placeholder = @"请输入定时名称";
        _timingTextView.textAlignment = NSTextAlignmentCenter;
        _timingTextView.font = [UIFont sf_systemFontOfSize:15];
        [_timingTextView setValue:[UIFont sf_systemFontOfSize:8] forKeyPath:@"_placeholderLabel.font"];
    }
    return _timingTextView;
}

- (UIImageView *)sepImgView
{
    if (!_sepImgView) {
        _sepImgView = [UIImageView new];
        _sepImgView.image = [UIImage imageNamed:@"giuy"];
    }
    return _sepImgView;
}

- (UILabel *)subLb
{
    if (!_subLb) {
        _subLb = [UILabel new];
        _subLb.font = [UIFont sf_systemFontOfSize:10];
        _subLb.text = @"请在对应的颜色图表上设置亮度";
        _subLb.textAlignment = NSTextAlignmentLeft;
    }
    return _subLb;
}

- (LightControlView *)whiteLcView
{
    if (!_whiteLcView) {
        _whiteLcView = [LightControlView new];
        _whiteLcView.btnColor = [UIColor whiteColor];
        _whiteLcView.delegate = self;
    }
    return _whiteLcView;
}

- (LightControlView *)sapphireBlueLcView
{
    if (!_sapphireBlueLcView) {
        _sapphireBlueLcView = [LightControlView new];
        _sapphireBlueLcView.btnColor = UICOLORFROMRGB(0x69cef9);
        _sapphireBlueLcView.delegate = self;
    }
    return _sapphireBlueLcView;
}

- (LightControlView *)blueLcView
{
    if (!_blueLcView) {
        _blueLcView = [LightControlView new];
        _blueLcView.btnColor = [UIColor blueColor];
        _blueLcView.delegate = self;
    }
    return _blueLcView;
}


- (LightControlView *)greenLcView
{
    if (!_greenLcView) {
        _greenLcView = [LightControlView new];
        _greenLcView.btnColor = [UIColor greenColor];
        _greenLcView.delegate = self;
    }
    return _greenLcView;
}

- (LightControlView *)redLcView
{
    if (!_redLcView) {
        _redLcView = [LightControlView new];
        _redLcView.btnColor = [UIColor redColor];
        _redLcView.delegate = self;
    }
    return _redLcView;
}

- (LightControlView *)puepleLcView
{
    if (!_puepleLcView) {
        _puepleLcView = [LightControlView new];
        _puepleLcView.btnColor = [UIColor purpleColor];
        _puepleLcView.delegate = self;
    }
    return _puepleLcView;
}

- (TimingChartView *)lineChartView
{
    if (!_lineChartView) {
        _lineChartView = [TimingChartView new];
        _lineChartView.delegate = self;
        [_lineChartView setSelectedIndex:0];
    }
    return _lineChartView;
}

- (UIButton *)spsBtn
{
    if (!_spsBtn) {
        _spsBtn = [UIButton new];
        [_spsBtn addTarget:self action:@selector(spsBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_spsBtn setTitle:@"载入预设" forState:UIControlStateNormal];
        [_spsBtn setBackgroundColor:[UIColor clearColor]];
        [_spsBtn.titleLabel setFont:[UIFont sf_systemFontOfSize:8]];
        _spsBtn.layer.masksToBounds = YES;
        _spsBtn.layer.cornerRadius = CurrentDeviceSize(5);
        [_spsBtn setBackgroundImage:[UIImage imageNamed:@"btnBg"] forState:UIControlStateNormal];
        [_spsBtn.titleLabel setTextColor:[UIColor whiteColor]];
    }
    return _spsBtn;
}

- (UIButton *)saveBtn
{
    if (!_saveBtn) {
        _saveBtn = [UIButton new];
        [_saveBtn addTarget:self action:@selector(saveBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_saveBtn setImage:[UIImage imageNamed:@"button3"] forState:UIControlStateNormal];
        [_saveBtn setBackgroundColor:[UIColor clearColor]];
        _saveBtn.layer.masksToBounds = YES;
        _saveBtn.layer.cornerRadius = CurrentDeviceSize(5);
    }
    return _saveBtn;
}

- (UIButton *)deleteBtn
{
    if (!_deleteBtn) {
        _deleteBtn = [UIButton new];
        [_deleteBtn addTarget:self action:@selector(deleteBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_deleteBtn setImage:[UIImage imageNamed:@"button4"] forState:UIControlStateNormal];
        [_deleteBtn setBackgroundColor:[UIColor clearColor]];
        _deleteBtn.layer.masksToBounds = YES;
        _deleteBtn.layer.cornerRadius = CurrentDeviceSize(5);
    }
    return _deleteBtn;
}

- (UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [UIButton new];
        [_closeBtn addTarget:self action:@selector(closeBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_closeBtn setImage:[UIImage imageNamed:@"X"] forState:UIControlStateNormal];
    }
    return _closeBtn;
}

- (PreinstallSelectView *)selectView
{
    if (!_selectView) {
        _selectView = [PreinstallSelectView new];
        _selectView.delegate = self;
        _selectView.layer.cornerRadius = 5;
        _selectView.layer.masksToBounds = YES;
        self.selectView.hidden = YES;
    }
    return _selectView;
}

//- (void)setSchTask:(DeviceSchedulerTask *)schTask
//{
//    _schTask = schTask;
//    NSArray<DeviceCommonSchulder *> *sches = schTask.sches;
//    NSString *key = sches[0].attrs.allKeys.firstObject;
//    NSDictionary *dic = @{@"color_white":@0,@"color_blue1":@1,@"color_blue2":@2,@"color_green":@3,@"color_red":@4,@"volor_violet":@5};
//    for (int i=0; i<sches.count; i++) {
//        id value = sches[i].attrs[key];
//        NSInteger index = [sches[i].time componentsSeparatedByString:@":"].firstObject.integerValue;
//        [self.tempArr replaceObjectAtIndex:index withObject:value];
//    }
//    NSInteger selecteIndex = [dic[key] integerValue];
//    //设置定时名称
//    NSArray *taskNameArr = [schTask.taskName componentsSeparatedByString:@"_"];
//    self.timingTextView.text = taskNameArr.firstObject;
//
//    [self.lineChartView setChartSchValues:self.tempArr];
//
//    if (selecteIndex == 0) {
//        [self.lineChartView setSelectedIndex:0];
//        self.currentIndex = 0;
//        self.currentSelectView = self.whiteLcView;
//    }else if (selecteIndex == 1){
//        [self.lineChartView setSelectedIndex:1];
//        self.currentIndex = 1;
//        self.currentSelectView = self.sapphireBlueLcView;
//    }else if (selecteIndex == 2){
//        [self.lineChartView setSelectedIndex:2];
//        self.currentIndex = 2;
//        self.currentSelectView = self.blueLcView;
//    }else if (selecteIndex == 3){
//        [self.lineChartView setSelectedIndex:3];
//        self.currentIndex = 3;
//        self.currentSelectView = self.greenLcView;
//    }else if (selecteIndex == 4){
//        [self.lineChartView setSelectedIndex:4];
//        self.currentIndex = 4;
//        self.currentSelectView = self.redLcView;
//    }else if (selecteIndex == 5){
//        [self.lineChartView setSelectedIndex:5];
//        self.currentIndex = 5;
//        self.currentSelectView = self.puepleLcView;
//    }
//}

- (NSMutableArray *)tempArr
{
    if (!_tempArr) {
        _tempArr = [NSMutableArray array];
        for (int i =0; i<24; i++) {
            [_tempArr addObject:@" "];
        }
    }
    return _tempArr;
}

- (void)setType:(NSString *)type
{
    _type = type;
    self.timingTextView.text = type;
    if ([type isEqualToString:@"LPS"]) {
        [self.lineChartView setChartSchValues:kLPS[0]];
        [self setupTempValuesWithArrays:kLPS];
        self.yusheSelected = 1;
    }else if ([type isEqualToString:@"SPS"])
    {
        [self.lineChartView setChartSchValues:kSPS[0]];
        [self setupTempValuesWithArrays:kSPS];
        self.yusheSelected = 0;
    }
    [self.lineChartView setSelectedIndex:0];
    self.currentIndex = 0;
    self.currentSelectView = self.whiteLcView;
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

#pragma mark 预设颜色数组 暂时还没动
- (NSMutableArray *)lpsDemo {
    if (!_lpsDemo) {
        _lpsDemo = [NSMutableArray array];
    }
    return _lpsDemo;
}

- (NSMutableArray *)spsDemo {
    
    if (!_spsDemo) {
        _spsDemo = [NSMutableArray array];
    }
    return _spsDemo;
}

@end
