//
//  APControlViewController.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/16.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "MyDeviceAddNextViewController.h"

@interface MyDeviceAddNextViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *handImageView;
@property (weak, nonatomic) IBOutlet UIImageView *lampImageView;
@property (weak, nonatomic) IBOutlet UILabel *upLabel;
@property (weak, nonatomic) IBOutlet UILabel *downLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (assign, nonatomic) BOOL isRed;
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation MyDeviceAddNextViewController

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    LHWeakSelf(self)
    
    ActionBlock leftAction = ^(UIButton *btn){
        [weakself.navigationController popViewControllerAnimated:YES];
    };
    [self.naviBar  configNavigationBarWithAttrs:@{
                                                  kCustomNaviBarLeftActionKey:leftAction,
                                                  kCustomNaviBarLeftImgKey:@"back",
                                                  kCustomNaviBarTitleKey:@"添加设备",
                                                  }];
    
    [self configContentView];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.timer invalidate];
    self.timer = nil;
}


-(void)configContentView{
    self.bgView.hidden = YES;
    self.upLabel.text = [NSString stringWithFormat:@"%@",@"1.长按设备开关5秒，看到红绿灯闪烁时放开。"];
    self.downLabel.text = [NSString stringWithFormat:@"%@",@"2.如红绿灯已交替闪烁，可忽略步骤1，点击下一步继续。"];
    self.handImageView.layer.masksToBounds = YES;
    self.handImageView.layer.cornerRadius = 15;
    self.lampImageView.layer.masksToBounds = YES;
    self.lampImageView.layer.cornerRadius = 20;
    self.lampImageView.backgroundColor = [UIColor redColor];
    _isRed = YES;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.25f target:self selector:@selector(changeLampColor) userInfo:nil repeats:YES];

}


- (IBAction)nextBtnDidClicked:(id)sender {
    [self nextBtnClicked];
}

-(void)changeLampColor{
    self.isRed = !self.isRed;
    if (self.isRed) {
        self.lampImageView.backgroundColor = [UIColor redColor];
    }else{
        self.lampImageView.backgroundColor = [UIColor greenColor];
    }
}

- (void)nextBtnClicked
{
    [self.navigationController pushViewController:[NSClassFromString(@"MyDeviceWIFIViewController") new] animated:YES];
}


@end
