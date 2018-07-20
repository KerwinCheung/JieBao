//
//  MyDeviceAddSuccessViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/18.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "MyDeviceAddSuccessViewController.h"

@interface MyDeviceAddSuccessViewController ()

@property (nonatomic, strong) UIImageView *successImgView;

@property (nonatomic, strong) UILabel *successLb;

@property (nonatomic, strong) UIButton *useBtn;

@end

@implementation MyDeviceAddSuccessViewController

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
                                                  kCustomNaviBarTitleKey:@"设备成功添加",
                                                  }];
}

- (void)initUI
{
    LHWeakSelf(self)
    [self.view addSubview:self.successImgView];
    [self.view addSubview:self.successLb];
    [self.view addSubview:self.useBtn];
    
    [self.successImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.centerY.equalTo(weakself.view.mas_centerY).offset(-CurrentDeviceSize(100));
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(100), CurrentDeviceSize(100)));
    }];
    
    [self.successLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.top.equalTo(weakself.successImgView.mas_bottom).offset(CurrentDeviceSize(30));
        make.width.lessThanOrEqualTo(@300);
    }];
    
    [self.useBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.right.equalTo(weakself.view.mas_right).offset(-CurrentDeviceSize(20));
        make.bottom.equalTo(weakself.view.mas_bottom).offset(-CurrentDeviceSize(100));
        make.height.equalTo(@(CurrentDeviceSize(35)));
    }];
}

- (void)useBtnClicked
{
    [self.navigationController popToViewController:self.navigationController.topViewController animated:YES];
}

#pragma mark - lazy init 
- (UIImageView *)successImgView
{
    if (!_successImgView) {
        _successImgView = [UIImageView new];
        _successImgView.image = [UIImage imageNamed:@"queren"];
    }
    return _successImgView;
}

- (UILabel *)successLb
{
    if (!_successLb) {
        _successLb = [UILabel new];
        _successLb.font = [UIFont sf_systemFontOfSize:16];
        _successLb.text = @"设备添加成功";
    }
    return _successLb;
}

- (UIButton *)useBtn
{
    if (!_useBtn) {
        _useBtn = [UIButton new];
        [_useBtn addTarget:self action:@selector(useBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_useBtn setTitle:@"立即使用" forState:UIControlStateNormal];
        [_useBtn setBackgroundImage:[UIImage imageNamed:@"btnBg"] forState:UIControlStateNormal];
        [_useBtn.titleLabel setTextColor:[UIColor whiteColor]];
        _useBtn.layer.masksToBounds = YES;
        _useBtn.layer.cornerRadius = CurrentDeviceSize(5);
    }
    return _useBtn;
}
@end
