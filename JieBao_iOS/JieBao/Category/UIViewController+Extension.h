//
//  UIViewController+Extension.h
//  LvTaotao
//
//  Created by XMYY-21 on 2018/4/2.
//  Copyright © 2018年 Kerwin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Extension)


#pragma mark - loadVC

+ (instancetype)controllerFromXIB;

+ (instancetype)controllerFromStoryboard:(NSString *)sbName;

- (id)loadViewControllerWithStoryboardName:(NSString *)sbName withViewControllerName:(NSString *)vcName;

-(UIAlertController *)showWarningAlert:(NSString *)msg;
-(UIAlertController *)showWarningAlert:(NSString *)msg didFinish:(void (^)(void))finish;
-(UIAlertController *)showWarningAlert:(NSString *)msg withTitle:(NSString *)title didFinish:(void (^)(void))finish;

@end
