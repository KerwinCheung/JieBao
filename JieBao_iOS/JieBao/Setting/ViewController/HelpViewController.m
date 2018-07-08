//
//  HelpViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/16.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "HelpViewController.h"

@interface HelpViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *wb;

@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.wb];
    [self.wb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@""]]];
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
                                                  kCustomNaviBarTitleKey:@"使用帮助"
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
