//
//  AboutUsController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/6/11.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "AboutUsController.h"

@interface AboutUsController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *wb;

@end

@implementation AboutUsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.wb];
    [self.wb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@""]]];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tabBarController.tabBar setHidden:YES];

    LHWeakSelf(self)
    
    ActionBlock leftAction = ^(UIButton *btn){
        [weakself.navigationController popViewControllerAnimated:YES];
        LHLog(@"left");
    };
    [self.naviBar  configNavigationBarWithAttrs:@{
                                                  kCustomNaviBarLeftActionKey:leftAction,
                                                  kCustomNaviBarLeftImgKey:@"back",
                                                  kCustomNaviBarTitleKey:@"关于我们"
                                                  }];
}

- (UIWebView *)wb
{
    if (!_wb) {
        _wb = [[UIWebView alloc] initWithFrame:CGRectMake(0, LL_StatusBarAndNavigationBarHeight, LL_ScreenWidth, LL_ScreenHeight - LL_StatusBarAndNavigationBarHeight)];
        _wb.delegate = self;
    }
    return _wb;
}

@end
