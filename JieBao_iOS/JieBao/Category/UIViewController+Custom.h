//
//  UIViewController+Custom.h
//  JieBao
//
//  Created by yangzhenmin on 2018/4/14.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ConfirmCallback)(void);
typedef void(^CancelCallback)(void);

@interface UIViewController (Custom)

- (void)alertShowMessage:(NSString *)message title:(NSString *)title leftBtnText:(NSString *)leftText  rightBtnText:(NSString *)rightText leftCallback:(ConfirmCallback)leftCallback rightCallback:(CancelCallback)rightCallback;

- (void)alertShowMessage:(NSString *)message title:(NSString *)title confirmCallback:(ConfirmCallback)confirmCallback cancelCallback:(CancelCallback)cancelCallback;

- (void)alertShowMessage:(NSString *)message title:(NSString *)title confirmBtnText:(NSString *)rightText confirmCallback:(CancelCallback)rightCallback;

- (void)actionSheetShowMessage:(NSArray *)messages confirmCallbacks:(NSArray<ConfirmCallback> *)confirmCallbacks cancelCallback:(CancelCallback)cancelCallback;


@end
