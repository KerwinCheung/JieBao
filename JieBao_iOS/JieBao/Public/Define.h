//
//  Define.h
//  JieBao
//
//  Created by yangzhenmin on 2018/4/12.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#ifndef Define_h
#define Define_h
// UIScreen width.
#define LL_ScreenWidth [UIScreen mainScreen].bounds.size.width

// UIScreen height.
#define LL_ScreenHeight [UIScreen mainScreen].bounds.size.height
// iPhone X
#define LL_iPhoneX (LL_ScreenWidth == 375.f && LL_ScreenHeight == 812.f ? YES : NO)

// Status bar height.
#define LL_StatusBarHeight (LL_iPhoneX ? 44.f : 20.f)

// Navigation bar height.
#define LL_NavigationBarHeight 44.f

// Tabbar height.
#define LL_TabbarHeight (LL_iPhoneX ? (49.f+34.f) : 49.f)

// Tabbar safe bottom margin.
#define LL_TabbarSafeBottomMargin (LL_iPhoneX ? 34.f : 0.f)

// Status bar & navigation bar height.
#define LL_StatusBarAndNavigationBarHeight (LL_iPhoneX ? 88.f : 64.f)

#define LL_ViewSafeAreInsets(view) ({UIEdgeInsets insets; if(@available(iOS 11.0, *)) {insets = view.safeAreaInsets;} else {insets = UIEdgeInsetsZero;} insets;})

#define IPHONE6WIDTH 375

#define SCALECONST  LL_ScreenWidth/IPHONE6WIDTH

#define CurrentDeviceSize(X) X*SCALECONST

#ifdef DEBUG
#define LHLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define LHLog(...)
#endif

#define LHWeakSelf(type)  __weak typeof(type) weak##type = type;

//rgb颜色转换（16进制->10进制）
#define UICOLORFROMRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define UICOLORFROMRGBA(rgbValue, a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:a]

#define SystemVersion [[UIDevice currentDevice] systemVersion].floatValue


#endif /* Define_h */
