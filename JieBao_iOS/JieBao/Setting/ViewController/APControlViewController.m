//
//  APControlViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/16.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "APControlViewController.h"

@interface APControlViewController ()

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *textLb;

@property (nonatomic, strong) UIButton *nextBtn;
@end

@implementation APControlViewController

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UICOLORFROMRGB(0xededed);
    [self.view addSubview:self.imgView];
    [self.view addSubview:self.textLb];
    [self.view addSubview:self.nextBtn];
    
    LHWeakSelf(self)
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(220), CurrentDeviceSize(140)));
        make.centerY.equalTo(weakself.view.mas_centerY).offset(-CurrentDeviceSize(10));
    }];
    
    [self.textLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.top.equalTo(weakself.imgView.mas_bottom).offset(CurrentDeviceSize(20));
        make.width.lessThanOrEqualTo(@200);
    }];
    
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.bottom.equalTo(weakself.view.mas_bottom).offset(-CurrentDeviceSize(100));
        make.width.equalTo(weakself.imgView.mas_width);
        make.height.equalTo(@(CurrentDeviceSize(35)));
    }];
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
                                                  kCustomNaviBarTitleKey:@"AP控制",
                                                  }];
}

- (void)nextBtnClicked
{
    [self.navigationController pushViewController:[NSClassFromString(@"APNextViewController") new] animated:YES];
}

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [UIImageView new];
    }
    return _imgView;
}

- (UILabel *)textLb
{
    if (!_textLb) {
        _textLb = [UILabel new];
        _textLb.font = [UIFont sf_systemFontOfSize:13];
        _textLb.text = @"请长按设备开关5秒使其进入AP模式";
    }
    return _textLb;
}

- (UIButton *)nextBtn
{
    if (!_nextBtn) {
        _nextBtn = [UIButton new];
        [_nextBtn addTarget:self action:@selector(nextBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_nextBtn setBackgroundImage:[UIImage imageNamed:@"btnBg"] forState:UIControlStateNormal];
        [_nextBtn.titleLabel setTextColor:[UIColor whiteColor]];
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    }
    return _nextBtn;
}
@end
