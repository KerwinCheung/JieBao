//
//  WIFIControlViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/17.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "WIFIControlViewController.h"

@interface WIFIControlViewController ()

@property (nonatomic, strong) UILabel *textLb;

@property (nonatomic, strong) UIButton *startBtn;

@end

@implementation WIFIControlViewController

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UICOLORFROMRGB(0xededed);
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    LHWeakSelf(self)
    ActionBlock leftAction = ^(UIButton *btn){
        [weakself.navigationController popViewControllerAnimated:YES];
        LHLog(@"left");
    };
    [self.naviBar  configNavigationBarWithAttrs:@{
                                                  kCustomNaviBarLeftActionKey:leftAction,
                                                  kCustomNaviBarLeftImgKey:@"back",
                                                  kCustomNaviBarTitleKey:@"WIFI控制",
                                                  }];
}

- (void)initUI
{
    [self.view addSubview:self.textLb];
    [self.view addSubview:self.startBtn];
    
    LHWeakSelf(self)
    [self.textLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.right.equalTo(weakself.view.mas_right).offset(-CurrentDeviceSize(20));
        make.centerY.equalTo(weakself.view.mas_centerY).offset(-CurrentDeviceSize(50));
        make.height.lessThanOrEqualTo(@(CurrentDeviceSize(200)));
    }];
    
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.right.equalTo(weakself.view.mas_right).offset(-CurrentDeviceSize(20));
        make.height.equalTo(@(CurrentDeviceSize(35)));
        make.bottom.equalTo(weakself.view.mas_bottom).offset(-CurrentDeviceSize(100));
    }];
}

- (void)startBtnClicked
{
    [self.navigationController pushViewController:[NSClassFromString(@"MyDeviceViewController") new] animated:YES];
}

- (UILabel *)textLb
{
    if (!_textLb) {
        _textLb = [UILabel new];
        _textLb.font = [UIFont sf_systemFontOfSize:14];
        _textLb.text = @"为了确保使用正常请检查一下步骤:\n1、请查看设备上的指示灯是否已经切换为wifi控制\n2、假若还未进行设备添加请先添加设备";
        _textLb.numberOfLines = 0;
    }
    return _textLb;
}

- (UIButton *)startBtn
{
    if (!_startBtn) {
        _startBtn = [UIButton new];
        [_startBtn setTitle:@"开始使用" forState:UIControlStateNormal];
        [_startBtn setBackgroundImage:[UIImage imageNamed:@"btnBg"] forState:UIControlStateNormal];
        [_startBtn.titleLabel setTextColor:[UIColor whiteColor]];
        [_startBtn addTarget:self action:@selector(startBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _startBtn;
}
@end
