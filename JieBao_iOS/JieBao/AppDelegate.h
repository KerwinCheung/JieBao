//
//  AppDelegate.h
//  JieBao
//
//  Created by yangzhenmin on 2018/4/12.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) SDKHelper *sdkHelper;

@property  (nonatomic, assign) NSInteger allowRotation;

- (void)changeRootViewController;

@end

