//
//  MyDevicecContractErrorViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/18.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "MyDevicecContractErrorViewController.h"
#import "MyDeviceWIFIViewController.h"
@interface MyDevicecContractErrorViewController ()

@property (nonatomic, strong) UIImageView *errorImgView;

@property (nonatomic, strong) UILabel *errorLb;

@property (nonatomic, strong) UILabel *tipLb;

@property (nonatomic, strong) UIButton *backBtn;

@end

@implementation MyDevicecContractErrorViewController

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.naviBar  configNavigationBarWithAttrs:@{

                                                  kCustomNaviBarTitleKey:@"添加设备",
                                                  }];
}

- (void)initUI
{
    [self.view addSubview:self.errorImgView];
    [self.view addSubview:self.errorLb];
    [self.view addSubview:self.tipLb];
    [self.view addSubview:self.backBtn];

    [self makeContraints];
}

- (void)makeContraints
{
    LHWeakSelf(self)
    [self.errorImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.centerY.equalTo(weakself.view.mas_centerY).offset(-CurrentDeviceSize(100));
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(100), CurrentDeviceSize(100)));
    }];
    
    [self.errorLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.top.equalTo(weakself.errorImgView.mas_bottom).offset(CurrentDeviceSize(30));
        make.width.lessThanOrEqualTo(@300);
    }];
    
    
    [self.tipLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.right.equalTo(weakself.view.mas_right).offset(-CurrentDeviceSize(20));
        make.top.equalTo(weakself.errorLb.mas_bottom).offset(CurrentDeviceSize(30));
        make.height.lessThanOrEqualTo(@(CurrentDeviceSize(200)));
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.view.mas_centerX);
        make.top.equalTo(weakself.tipLb.mas_bottom).offset(CurrentDeviceSize(40));
        make.height.equalTo(@(CurrentDeviceSize(35)));
        make.width.equalTo(@(LL_ScreenWidth - CurrentDeviceSize(40)));
    }];
}

- (void)backBtnClicked
{
    MyDeviceWIFIViewController *wifiVC = nil;
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[MyDeviceWIFIViewController class]]) {
            wifiVC = (MyDeviceWIFIViewController *)vc;
        }
    }
    [self.navigationController popToViewController:wifiVC animated:YES];
}


#pragma mark - lazy init
- (UIImageView *)errorImgView
{
    if (!_errorImgView) {
        _errorImgView = [UIImageView new];
        _errorImgView.image = [UIImage imageNamed:@"bb"];
    }
    return _errorImgView;
}

- (UILabel *)errorLb
{
    if (!_errorLb) {
        _errorLb = [UILabel new];
        _errorLb.font = [UIFont sf_systemFontOfSize:15];
        _errorLb.text = @"WiFi配置失败";
    }
    return _errorLb;
}


- (UILabel *)tipLb
{
    if (!_tipLb) {
        _tipLb = [UILabel new];
        _tipLb.font = [UIFont sf_systemFontOfSize:13];
        _tipLb.numberOfLines = 0;
        _tipLb.text = @"请尝试以下步骤:\n\n1.请确认无线网络密码是否正确\n2.请检查无线网络是否正常\n3.请尝试重置设备";
    }
    return _tipLb;
}

- (UIButton *)backBtn
{
    if (!_backBtn) {
        _backBtn = [UIButton new];
        [_backBtn addTarget:self action:@selector(backBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn setBackgroundImage:[UIImage imageNamed:@"btnBg"] forState:UIControlStateNormal];
        [_backBtn.titleLabel setTextColor:[UIColor whiteColor]];
        [_backBtn setTitle:@"重试" forState:UIControlStateNormal];
    }
    return _backBtn;
}
@end
