//
//  UIAlertController+showOnWindow.h
//  LvTaotao
//
//  Created by XMYY-21 on 2018/4/19.
//  Copyright © 2018年 Kerwin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertController (showOnWindow)

- (void)showOnWindow;

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
           leftActionTitle:(NSString *)leftActionTitle
           leftActionStyle:(UIAlertActionStyle)leftActionStyle
          leftActionHandle:(void(^)(UIAlertAction *action))leftActionHandle
          rightActionTitle:(NSString *)rightActionTitle
          rightActionStyle:(UIAlertActionStyle)rightActionStyle
         rightActionHandle:(void(^)(UIAlertAction *action))rightActionHandle;

@end
