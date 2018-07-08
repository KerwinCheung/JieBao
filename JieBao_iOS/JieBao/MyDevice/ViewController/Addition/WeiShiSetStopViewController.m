//
//  ZaoLangBengWeiShiStartTimeViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/6/19.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "WeiShiSetStopViewController.h"

@interface WeiShiSetStopViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pView;

@property (nonatomic, strong) UILabel *weishiStartLb;

@property (nonatomic, assign) NSInteger MSelectedIndex;

@end

@implementation WeiShiSetStopViewController

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
                                                  kCustomNaviBarTitleKey:@"设置暂停时间",
                                                  kCustomNaviBarRightImgKey:@"保存",
                                                  kCustomNaviBarRightActionKey:rightAction
                                                  }];
}

- (void)save
{
    if (self.callBack) {
        self.callBack([NSString stringWithFormat:@"%ld",self.MSelectedIndex]);
    }
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView

{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return  60;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *str = nil;
    if (row != self.MSelectedIndex) {
        str = [NSString stringWithFormat:@"%ld",row];
    }else
    {
        str = [NSString stringWithFormat:@"%ld  minute",row];
    }
    return str;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.MSelectedIndex = row;
    [pickerView reloadComponent:0];
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
        _weishiStartLb.text = @"请选择喂食暂停时间";
    }
    return _weishiStartLb;
}
@end
