//
//  AppDelegate.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/12.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseNavigationController.h"
#import "SDKHelper.h"
#import "LoginViewController.h"
@interface AppDelegate ()


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.sdkHelper = [SDKHelper shareInstance];
    [GizWifiSDK sharedInstance].delegate = self.sdkHelper;
    GizDeviceGroupCenter.delegate = self.sdkHelper;
    [GizDeviceSharing setDelegate:self.sdkHelper];
    [GizDeviceSchedulerCenter setDelegate:self.sdkHelper];
    [GizWifiSDK startWithAppInfo:@{@"appId":kAppId,@"appSecret":kAppSecrect} productInfo:nil cloudServiceInfo:nil autoSetDeviceDomain:NO];
    
    
    UIStoryboard *loginSB = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:nil];
    LoginViewController *loginVC = [loginSB instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    UINavigationController *vc = [[UINavigationController alloc] initWithRootViewController:loginVC];
    
    
    self.window.rootViewController = vc;
    return YES;
}


- (void)changeRootViewController
{
    NSArray *vcs = @[@"MyDeviceViewController",@"MyGroupViewController",@"SettingViewController"];
    NSArray *names = @[@"我的设备",@"我的分组",@"设置"];
    NSArray *normalImgs = @[@"shebei1",@"zuhe1",@"shezhi1"];
    NSArray *selectedImgs = @[@"shebei",@"zuhe",@"shezhi"];
    NSArray *textCols = @[UICOLORFROMRGB(0xcb480e),UICOLORFROMRGB(0xa3d822),UICOLORFROMRGB(0x2a87d0)];
    UITabBarController *tabarVc = [[UITabBarController alloc] init];
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0 ; i < vcs.count;i++) {
        NSString *name = vcs[i];
        UIViewController *vc = [[BaseNavigationController alloc] initWithRootViewController:[NSClassFromString(name) new]];
        vc.tabBarItem.image = [UIImage imageNamed:normalImgs[i]];
        [vc.tabBarItem setImage:[UIImage imageNamed:normalImgs[i]]];
        [vc.tabBarItem setSelectedImage:[[UIImage imageNamed:selectedImgs[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        vc.tabBarItem.title = names[i];
        [vc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:textCols[i]} forState:UIControlStateSelected];
        [arr addObject:vc];
    }
    tabarVc.viewControllers = arr;
    self.window.rootViewController = tabarVc;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     [[NSNotificationCenter defaultCenter] postNotificationName:UIApplicationDidEnterBackgroundNotification object:nil];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}




@end
