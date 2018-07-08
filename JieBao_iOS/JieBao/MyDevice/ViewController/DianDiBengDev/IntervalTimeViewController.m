//
//  IntervalTimeViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/5/14.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "IntervalTimeViewController.h"

@interface IntervalTimeViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UILabel *subLb;

@property (nonatomic, strong) UIPickerView *pView;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation IntervalTimeViewController

- (instancetype)init
{
    if (self = [super init]) {
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bgView.backgroundColor = UICOLORFROMRGB(0xededed);
    [self.bgView addSubview:self.subLb];
    [self.bgView addSubview:self.pView];
    
    LHWeakSelf(self)
    [self.subLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(CurrentDeviceSize(80)));
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.width.lessThanOrEqualTo(@200);
    }];
    
    [self.pView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.subLb.mas_bottom);
        make.left.right.equalTo(@0);
        make.height.equalTo(@(CurrentDeviceSize(200)));
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    LHWeakSelf(self)
    ActionBlock rightAction = ^(UIButton *btn){
        [weakself save];
        LHLog(@"保存");
    };
    
    ActionBlock leftAction = ^(UIButton *btn){
        [weakself.navigationController popViewControllerAnimated:YES];
        LHLog(@"left");
    };
    [self.naviBar  configNavigationBarWithAttrs:@{
                                                  kCustomNaviBarLeftActionKey:leftAction,
                                                  kCustomNaviBarLeftImgKey:@"back",
                                                  kCustomNaviBarTitleKey:@"间隔时间",
                                                  kCustomNaviBarRightImgKey:@"保存",
                                                  kCustomNaviBarRightActionKey:rightAction
                                                  }];
}

- (void)save
{
    if (self.callBack) {
        self.callBack(@(self.selectedIndex));
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView

{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 31;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *str = nil;
    if (row != self.selectedIndex) {
        str = [NSString stringWithFormat:@"%ld",row];
    }else
    {
        str = [NSString stringWithFormat:@"%ld  天",row];
    }
    return str;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedIndex = row;
    [pickerView reloadComponent:0];
}


- (UILabel *)subLb
{
    if (!_subLb) {
        _subLb = [UILabel new];
        _subLb.text = @"请选择间隔时间";
        _subLb.font = [UIFont sf_systemFontOfSize:13];
        _subLb.textAlignment = NSTextAlignmentLeft;
    }
    return _subLb;
}

- (UIPickerView *)pView
{
    if (!_pView) {
        _pView = [UIPickerView new];
        _pView.backgroundColor = [UIColor whiteColor];
        _pView.delegate = self;
        _pView.dataSource = self;
    }
    return _pView;
}

@end
