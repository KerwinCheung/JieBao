//
//  BaseViewController.h
//  JieBao
//
//  Created by yangzhenmin on 2018/4/12.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCustomNavigationBarView.h"

@interface BaseViewController : UIViewController

@property (nonatomic, strong, readonly) UIView *bgView;

@property (nonatomic, strong, readonly) BaseCustomNavigationBarView *naviBar;

@end
