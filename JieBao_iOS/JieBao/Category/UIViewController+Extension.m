//
//  UIViewController+Extension.m
//  LvTaotao
//
//  Created by XMYY-21 on 2018/4/2.
//  Copyright © 2018年 Kerwin. All rights reserved.
//

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)

#pragma mark - loadVC

+ (instancetype)controllerFromXIB {
    UIViewController * vc = [[self alloc]initWithNibName:NSStringFromClass(self.class) bundle:[NSBundle bundleForClass:self.class]];
    return vc;
}

+ (instancetype)controllerFromStoryboard:(NSString *)sbName {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:sbName bundle:[NSBundle bundleForClass:self.class]];
    id viewController = [storyboard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
    return viewController;
}

- (id)loadViewControllerWithStoryboardName:(NSString *)sbName withViewControllerName:(NSString *)vcName {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:sbName bundle:[NSBundle bundleForClass:self.class]];
    id viewController = [storyboard instantiateViewControllerWithIdentifier:vcName];
    return viewController;
}

#pragma mark - WarningAlert
-(UIAlertController *)showWarningAlert:(NSString *)msg{
    return [self showWarningAlert:msg didFinish:nil];
}

-(UIAlertController *)showWarningAlert:(NSString *)msg didFinish:(void (^)(void))finish{
    return [self showWarningAlert:msg withTitle:@"提示" didFinish:finish];
}

-(UIAlertController *)showWarningAlert:(NSString *)msg withTitle:(NSString *)title didFinish:(void (^)(void))finish{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (finish != nil) {
            finish();
        }
    }];
    [alertController addAction:okAction];
    [alertController showOnWindow];
    return alertController;
}

@end
