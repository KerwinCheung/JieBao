//
//  HudHelper.m
//  JieBao
//
//  Created by yangzhenmin on 2018/6/23.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "HudHelper.h"

@implementation HudHelper

+ (void)showStatus:(NSString *)status dismiss:(NSInteger)time
{
    [SVProgressHUD showWithStatus:status];
    [SVProgressHUD dismissWithDelay:time];
}

+ (void)showStatus:(NSString *)status
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self showStatus:status dismiss:2];
    });
}

+ (void)showErrorWithStatus:(NSString *)status
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showErrorWithStatus:status];
        [SVProgressHUD dismissWithDelay:2];
    });
}

+ (void)showSuccessWithStatus:(NSString *)status
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showSuccessWithStatus:status];
        [SVProgressHUD dismissWithDelay:2];
    });
}

+ (void)showInfoWithStatus:(NSString *)status
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD showInfoWithStatus:status];
        [SVProgressHUD dismissWithDelay:2];
    });
}

+ (void)show
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD show];
    });
}

+ (void)dismiss
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [SVProgressHUD dismiss];
    });
}

@end
