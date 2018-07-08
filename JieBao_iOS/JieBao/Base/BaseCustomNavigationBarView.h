//
//  BaseCustomNavigationBarView.h
//  JieBao
//
//  Created by yangzhenmin on 2018/4/16.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCustomNavigationBarView : UIView

@property (nonatomic, copy) NSString *title;

- (void)configNavigationBarWithAttrs:(NSDictionary *)attrs;

- (void)configRightBtnWithAttrs:(NSDictionary *)attrs;



@end
