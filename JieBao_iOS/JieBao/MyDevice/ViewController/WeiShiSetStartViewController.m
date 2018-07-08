//
//  ZaoLangBengWeiShiStartTimeViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/6/19.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "WeiShiSetStartViewController.h"


@interface WeiShiSetStartViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pView;

@property (nonatomic, strong) UILabel *weishiStartLb;

@property (nonatomic, assign) NSInteger HSelectedIndex;

@property (nonatomic, assign) NSInteger MSelectedIndex;

@end

@implementation WeiShiSetStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.bgView.backgroundColor = UICOLORFROMRGB(0xf8f8f8);
    [self.bgView addSubview:self.weishiStartLb];
    [self.bgView addSubview:self.pView];
    
    LHWeakSelf(self);
    [self.weishiStartLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.top.equalTo(@(CurrentDeviceSize(60)));
        make.width.lessThanOrEqualTo(@200);
    }];
    
    [self.pView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(@0);
        make.top.equalTo(weakself.weishiStartLb.mas_bottom).offset(CurrentDeviceSize(10));
        make.width.equalTo(@(CurrentDeviceSize(200)));
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];
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
                                                  kCustomNaviBarTitleKey:@"设置开始时间",
                                                  kCustomNaviBarRightImgKey:@"保存",
                                                  kCustomNaviBarRightActionKey:rightAction
                                                  }];
}


- (void)save
{
    if (self.callBack) {
        self.callBack([NSString stringWithFormat:@"%02ld:%02ld",self.HSelectedIndex,self.MSelectedIndex]);
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView

{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return component == 0 ? 24 : 60;;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%ld",row];;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        self.HSelectedIndex = row;
    }else
    {
        self.MSelectedIndex = row;
    }
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

- (UILabel *)weishiStartLb
{
    if (!_weishiStartLb) {
        _weishiStartLb = [UILabel new];
        _weishiStartLb.font = [UIFont sf_systemFontOfSize:13];
        _weishiStartLb.text = @"请选择喂食开始时间";
    }
    return _weishiStartLb;
}
@end
