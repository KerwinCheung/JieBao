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

@property (nonatomic, strong) NSDictionary *dic;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) LightControlView *currentSelectView;

@property (nonatomic, strong) NSMutableArray *tempArr;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, assign) NSInteger sucCount;

@property (nonatomic, assign) int yusheSelected;


//颜色数值数组
@property (nonatomic, strong) NSMutableArray <NSNumber *> *whiteValues;
@property (nonatomic, strong) NSMutableArray <NSNumber *> *blue1Values;
@property (nonatomic, strong) NSMutableArray <NSNumber *> *blue2Values;
@property (nonatomic, strong) NSMutableArray <NSNumber *> *greenValues;
@property (nonatomic, strong) NSMutableArray <NSNumber *> *redValues;
@property (nonatomic, strong) NSMutableArray <NSNumber *> *violetValues;

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
    
    [self.view addSubview:self.selectView];
    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakself.view);
        make.size.mas_offset(CGSizeMake(LL_ScreenWidth/2, CurrentDeviceSize(CurrentDeviceSize(44*2+30))));
    }];
}


#pragma mark - buttonAction
- (void)spsBtnClicked
{
    self.selectView.hidden = NO;
}

#pragma mark 载入预设值
- (void)lpsSelected
{
//    NSArray *temp = [NSArray arrayWithArray:kLPS];
    [self.lineChartView setChartSchValues:kLPS[self.currentIndex]];
//   @[ @[@"0",@"0",@"0",@"0",@"0",@"0",@"5",@"10",@"15",@"20",@"25",@"30",@"40",@"51",@"62",@"62",@"51",@"40",@"30",@"25",@"20",@"15",@"10",@"0"], @[@"0",@"0",@"0",@"0",@"0",@"0",@"3",@"8",@"20",@"30",@"40",@"50",@"60",@"70",@"80",@"80",@"70",@"60",@"50",@"40",@"30",@"20",@"8",@"0"], @[@"0",@"0",@"0",@"0",@"0",@"0",@"5",@"15",@"30",@"45",@"56",@"68",@"75",@"85",@"90",@"90",@"85",@"75",@"68",@"56",@"45",@"30",@"15",@"0"], @[@"0",@"0",@"0",@"0",@"0",@"0",@"3",@"5",@"8",@"10",@"12",@"15",@"20",@"25",@"30",@"30",@"25",@"20",@"15",@"12",@"10",@"8",@"5",@"0"], @[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"3",@"3",@"6",@"8",@"10",@"13",@"17",@"20",@"20",@"17",@"13",@"10",@"8",@"6",@"3",@"3",@"0"], @[@"0",@"0",@"0",@"0",@"0",@"0",@"3",@"6",@"18",@"20",@"25",@"30",@"40",@"51",@"62",@"62",@"51",@"40",@"30",@"25",@"20",@"18",@"6",@"0"]
//  ];
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

#pragma mark 保存按钮
- (void)saveBtnClicked
{
    if ([self.nameSoure containsObject:self.timingTextView.text]) {
        [HudHelper showInfoWithStatus:@"请修改定时任务名字"];
        return;
    }

    NSString *str = self.dic[@(self.currentIndex)];
//    NSMutableDictionary *attrsDic = [NSMutableDictionary dictionary];
//    @weakify(attrsDic);
//    [self.dic enumerateKeysAndObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//        @strongify(attrsDic);
//        [attrsDic setObject:@"" forKey:obj];
//    }];
    
    [SVProgressHUD show];
    self.count = 0;
    self.sucCount = 0;
    @weakify(self);
    for (int i = 0; i < 24; i++)
    {
        NSMutableDictionary *body = [NSMutableDictionary
                                     dictionaryWithDictionary:@{
                                                                @"attrs":@{str:@([self.lineChartView getChartValues][i].integerValue),
                                                                           @"Timer" :@(1)
                                                                           },
                                                                @"date":[[NSDate dateWithTimeInterval:24*60*60 sinceDate:[NSDate date]] formattedDateWithFormat:@"yyyy-MM-dd"],
                                                                @"time":[NSString stringWithFormat:@"%02d:00",i],
                                                                @"repeat":@"none",
                                                                @"enabled":@(NO),
                                                                @"remark":self.timingTextView.text}];
        if (self.dev) {
            [body setObject:self.dev.did forKey:@"did"];
        }else
        {
            [body setObject:self.group.gid forKey:@"group_id"];
        }
        [NetworkHelper sendRequest:body Method:@"POST" Path:@"https://api.gizwits.com/app/common_scheduler" callback:^(NSData *data, NSError *error) {
            @strongify(self);
//            @synchronized(self)
//            {
//                self.count++;
//            }
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
                }else
                {
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

#pragma mark 上方颜色按钮回调
- (void)colorBlockClicked:(id)view
{
    if (self.currentSelectView) {
        self.currentSelectView.isClicked = NO;
    }
    
    if ([view isEqual:self.whiteLcView])
    {
        [self.lineChartView setSelectedIndex:0];
        self.currentIndex = 0;
        self.currentSelectView = self.whiteLcView;
    }
    else if ([view isEqual:self.sapphireBlueLcView])
    {
        [self.lineChartView setSelectedIndex:1];
        self.currentIndex = 1;
        self.currentSelectView = self.sapphireBlueLcView;
    }
    else if ([view isEqual:self.blueLcView])
    {
        [self.lineChartView setSelectedIndex:2];
        self.currentIndex = 2;
        self.currentSelectView = self.blueLcView;
    }
    else if ([view isEqual:self.greenLcView])
    {
        [self.lineChartView setSelectedIndex:3];
        self.currentIndex = 3;
        self.currentSelectView = self.greenLcView;
    }
    else if ([view isEqual:self.redLcView])
    {
        [self.lineChartView setSelectedIndex:4];
        self.currentIndex = 4;
        self.currentSelectView = self.redLcView;
    }
    else if ([view isEqual:self.puepleLcView])
    {
        [self.lineChartView setSelectedIndex:5];
        self.currentIndex = 5;
        self.currentSelectView = self.puepleLcView;
    }
    
    if (self.yusheSelected >= 0) {
        [self selectIndex:self.yusheSelected];
    }
}

- (void)selectIndex:(NSInteger)index
{
    self.yusheSelected = (int)index;
    if (0 == index)
    {
        [self spsSelected];
    }
    else if (1 == index)
    {
        [self lpsSelected];
    }
    else if (2 == index)
    {
        [self growthSelected];
    }
    else if (3 == index)
    {
        [self reefAquariumSelected];
    }
    self.selectView.hidden = YES;
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
        self.selectView.hidden = YES;
    }
    return _selectView;
}

- (void)setSchTask:(DeviceSchedulerTask *)schTask
{
    _schTask = schTask;
    NSArray<DeviceCommonSchulder *> *sches = schTask.sches;
    NSString *key = sches[0].attrs.allKeys.firstObject;
    NSDictionary *dic = @{@"color_white":@0,@"color_blue1":@1,@"color_blue2":@2,@"color_green":@3,@"color_red":@4,@"volor_violet":@5};
    for (int i=0; i<sches.count; i++) {
        id value = sches[i].attrs[key];
        NSInteger index = [sches[i].time componentsSeparatedByString:@":"].firstObject.integerValue;
        [self.tempArr replaceObjectAtIndex:index withObject:value];
    }
    NSInteger selecteIndex = [dic[key] integerValue];
    self.timingTextView.text = schTask.taskName;
    [self.lineChartView setChartSchValues:self.tempArr];
    
    if (selecteIndex == 0) {
        [self.lineChartView setSelectedIndex:0];
        self.currentIndex = 0;
        self.currentSelectView = self.whiteLcView;
    }else if (selecteIndex == 1){
        [self.lineChartView setSelectedIndex:1];
        self.currentIndex = 1;
        self.currentSelectView = self.sapphireBlueLcView;
    }else if (selecteIndex == 2){
        [self.lineChartView setSelectedIndex:2];
        self.currentIndex = 2;
        self.currentSelectView = self.blueLcView;
    }else if (selecteIndex == 3){
        [self.lineChartView setSelectedIndex:3];
        self.currentIndex = 3;
        self.currentSelectView = self.greenLcView;
    }else if (selecteIndex == 4){
        [self.lineChartView setSelectedIndex:4];
        self.currentIndex = 4;
        self.currentSelectView = self.redLcView;
    }else if (selecteIndex == 5){
        [self.lineChartView setSelectedIndex:5];
        self.currentIndex = 5;
        self.currentSelectView = self.puepleLcView;
    }
}

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
        self.yusheSelected = 1;
    }else if ([type isEqualToString:@"SPS"])
    {
        [self.lineChartView setChartSchValues:kSPS[0]];
        self.yusheSelected = 0;
    }
    [self.lineChartView setSelectedIndex:0];
    self.currentIndex = 0;
    self.currentSelectView = self.whiteLcView;
}
@end
