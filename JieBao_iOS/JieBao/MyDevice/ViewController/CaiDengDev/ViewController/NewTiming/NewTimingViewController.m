//
//  NewTimingViewController.m
//  JieBao
//
//  Created by XMYY-21 on 2018/7/17.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "NewTimingViewController.h"
#import <JieBao-Swift.h>

@interface NewTimingViewController ()

@end

@implementation NewTimingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat width = UIScreen.mainScreen.bounds.size.height - 75;
    CGFloat height = UIScreen.mainScreen.bounds.size.width - 90;
    EditorCharts *chartsView = [[EditorCharts alloc]initWithFrame:CGRectMake(45, 70, width, height)];
    chartsView.yValue = @[@(25),@(35),@(340),@(60),@(70),@(50),@(20),@(18),@(19),@(9),@(35),@(100),@(25),@(35),@(340),@(60),@(70),@(50),@(20),@(18),@(19),@(9),@(60),@(70)];
    chartsView.lineColor = [UIColor redColor];
    [chartsView showCircleWithIsShow:true];
    chartsView.callBackYValueArray = ^(NSArray<NSNumber *> * _Nullable array) {
        NSLog(@"%@",array);
        NSLog(@"%zd",array[1].integerValue);
    };
    
    [self.view addSubview:chartsView];
}

- (IBAction)saveBtnAction:(UIButton *)sender {
    //保存定时
}

- (IBAction)cancelBtnAction:(UIButton *)sender {
    //取消
}

- (IBAction)deleteBtnAction:(UIButton *)sender {
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
