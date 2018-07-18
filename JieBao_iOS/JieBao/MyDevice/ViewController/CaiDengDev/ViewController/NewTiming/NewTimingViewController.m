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
@property (weak, nonatomic) IBOutlet UILabel *timingNameLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet EditorCharts *chartsView;

@end

@implementation NewTimingViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.chartsView.backgroundColor = [UIColor whiteColor];
    self.chartsView.yValue = @[@(25),@(35),@(340),@(60),@(70),@(50),@(20),@(18),@(19),@(9),@(35),@(100),@(25),@(35),@(340),@(60),@(70),@(50),@(20),@(18),@(19),@(9),@(60),@(70)];
    self.chartsView.lineColor = [UIColor redColor];
    [self.chartsView showCircleWithIsShow:true];
    self.chartsView.callBackYValueArray = ^(NSArray<NSNumber *> * _Nullable array) {
        NSLog(@"%@",array);
        NSLog(@"%zd",array[1].integerValue);
    };
}

- (IBAction)saveBtnAction:(UIButton *)sender {
    //保存定时
}

- (IBAction)cancelBtnAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
