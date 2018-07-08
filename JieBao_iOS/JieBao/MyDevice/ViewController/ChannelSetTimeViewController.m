//
//  IntervalTimeViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/5/14.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "ChannelSetTimeViewController.h"

@interface ChannelSetTimeViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UILabel *bujiLb;

@property (nonatomic, strong) UIView *bujiBgView;

@property (nonatomic, strong) UITextField *bujiTextView;

@property (nonatomic, strong) UILabel *bujiTimeLb;

@property (nonatomic, strong) UIPickerView *pView;

@property (nonatomic, assign) NSInteger HSelectedIndex;

@property (nonatomic, assign) NSInteger MSelectedIndex;
@end

@implementation ChannelSetTimeViewController

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
    [self ininUI];
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
                                                  kCustomNaviBarTitleKey:@"设置时间段",
                                                  kCustomNaviBarRightImgKey:@"保存",
                                                  kCustomNaviBarRightActionKey:rightAction
                                                  }];
}

- (void)ininUI
{
    [self.bgView addSubview:self.bujiLb];
    [self.bgView addSubview:self.bujiBgView];
    [self.bujiBgView addSubview:self.bujiTextView];
    [self.bgView addSubview:self.bujiTimeLb];
    [self.bgView addSubview:self.pView];
    
    LHWeakSelf(self)
    [self.bujiLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(CurrentDeviceSize(80)));
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.width.lessThanOrEqualTo(@200);
    }];
    
    [self.bujiBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.bujiLb.mas_bottom);
        make.left.right.equalTo(@0);
        make.height.equalTo(@(CurrentDeviceSize(44)));
    }];
    
    [self.bujiTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.left.equalTo(weakself.bujiLb);
        make.right.equalTo(weakself.bujiBgView.mas_right);
    }];
    
    [self.bujiTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.bujiBgView.mas_bottom).offset(CurrentDeviceSize(40));
        make.left.equalTo(weakself.bujiLb);
        make.width.lessThanOrEqualTo(@200);
    }];
    
    [self.pView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakself.bujiTimeLb.mas_bottom);
        make.left.right.equalTo(@0);
        make.height.equalTo(@(CurrentDeviceSize(200)));
    }];
}

- (void)save
{
    GizDeviceScheduler *scheduler = [GizDeviceScheduler schedulerDayRepeat:@{self.title:self.bujiTextView.text} time:[NSString stringWithFormat:@"%2ld:%2ld",self.HSelectedIndex,self.MSelectedIndex] monthDays:@[@10] enabled:NO remark:nil];
    if (self.callBack) {
        self.callBack(scheduler);
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

- (UILabel *)bujiLb
{
    if (!_bujiLb) {
        _bujiLb = [UILabel new];
        _bujiLb.text = @"补给量";
        _bujiLb.font = [UIFont sf_systemFontOfSize:13];
        _bujiLb.textAlignment = NSTextAlignmentLeft;
    }
    return _bujiLb;
}

- (UIView *)bujiBgView
{
    if (!_bujiBgView) {
        _bujiBgView = [UIView new];
        _bujiBgView.backgroundColor = [UIColor whiteColor];
    }
    return _bujiBgView;
}

- (UITextField *)bujiTextView
{
    if (!_bujiTextView) {
        _bujiTextView = [UITextField new];
        _bujiTextView.placeholder = @"请输入补给量";
        _bujiTextView.font = [UIFont sf_systemFontOfSize:13];
        _bujiTextView.clearButtonMode = UITextFieldViewModeWhileEditing;
        _bujiTextView.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _bujiTextView;
}

- (UILabel *)bujiTimeLb
{
    if (!_bujiTimeLb) {
        _bujiTimeLb = [UILabel new];
        _bujiTimeLb.text = @"请选择补给时间";
        _bujiTimeLb.font = [UIFont sf_systemFontOfSize:13];
        _bujiTimeLb.textAlignment = NSTextAlignmentLeft;
    }
    return _bujiTimeLb;
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
