//
//  UIViewController+Custom.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/14.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "UIViewController+Custom.h"

@implementation UIViewController (Custom)

- (void)alertShowMessage:(NSString *)message title:(NSString *)title leftBtnText:(NSString *)leftText  rightBtnText:(NSString *)rightText leftCallback:(ConfirmCallback)leftCallback rightCallback:(CancelCallback)rightCallback
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *left = [UIAlertAction actionWithTitle:leftText style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (leftCallback) {
            leftCallback();
        }
    }];
    [alert addAction:left];
    
    UIAlertAction *right = [UIAlertAction actionWithTitle:rightText style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (rightCallback) {
            rightCallback();
        }
    }];
    [alert addAction:right];
    [self presentViewController:alert animated:true completion:nil];
}

- (void)alertShowMessage:(NSString *)message title:(NSString *)title confirmCallback:(ConfirmCallback)confirmCallback cancelCallback:(CancelCallback)cancelCallback
{
    [self alertShowMessage:message title:title leftBtnText:@"取消" rightBtnText:@"确定" leftCallback:cancelCallback rightCallback:confirmCallback];
}

- (void)alertShowMessage:(NSString *)message title:(NSString *)title confirmBtnText:(NSString *)rightText confirmCallback:(CancelCallback)rightCallback
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *right = [UIAlertAction actionWithTitle:rightText style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (rightCallback) {
            rightCallback();
        }
    }];
    [alert addAction:right];
    [self presentViewController:alert animated:true completion:nil];
}


- (void)actionSheetShowMessage:(NSArray *)messages confirmCallbacks:(NSArray<ConfirmCallback> *)confirmCallbacks cancelCallback:(CancelCallback)cancelCallback
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:  UIAlertControllerStyleActionSheet];
    
    /**
     *  style参数：
     UIAlertActionStyleDefault,
     UIAlertActionStyleCancel,
     UIAlertActionStyleDestructive（默认按钮文本是红色的）
     *
     */
    //分别按顺序放入每个按钮；
    for (int i = 0;i<messages.count;i++ ) {
        NSString *msg = messages[i];
        ConfirmCallback confirmCallback = confirmCallbacks[i];
        [alert addAction:[UIAlertAction actionWithTitle:msg style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (confirmCallback) {
                confirmCallback();
            }
        }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        if (cancelCallback) {
              cancelCallback();
        }
    }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

@end
