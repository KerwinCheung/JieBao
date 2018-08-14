//
//  UIAlertController+showOnWindow.m
//  LvTaotao
//
//  Created by XMYY-21 on 2018/4/19.
//  Copyright © 2018年 Kerwin. All rights reserved.
//

#import "UIAlertController+showOnWindow.h"

@implementation UIAlertController (showOnWindow)

- (void)showOnWindow {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (rootViewController.presentedViewController) {
        rootViewController = rootViewController.presentedViewController;
    }
    [rootViewController presentViewController:self animated:YES completion:nil];
}

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
           leftActionTitle:(NSString *)leftActionTitle
           leftActionStyle:(UIAlertActionStyle)leftActionStyle
          leftActionHandle:(void(^)(UIAlertAction *action))leftActionHandle
          rightActionTitle:(NSString *)rightActionTitle
          rightActionStyle:(UIAlertActionStyle)rightActionStyle
         rightActionHandle:(void(^)(UIAlertAction *action))rightActionHandle
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:leftActionTitle
                                                           style:leftActionStyle
                                                         handler:leftActionHandle];
    [alertController addAction:cancleAction];
    
    UIAlertAction *okAlertAction = [UIAlertAction actionWithTitle:rightActionTitle style:rightActionStyle handler:rightActionHandle];
    [alertController addAction:okAlertAction];
    
    [alertController showOnWindow];
}

@end
