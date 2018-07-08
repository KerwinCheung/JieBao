//
//  UIFont+Custom.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/12.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "UIFont+Custom.h"

@implementation UIFont (Custom)

+ (UIFont *)sf_systemFontOfSize:(CGFloat)fontSize
{
    CGFloat size = LL_ScreenWidth/IPHONE6WIDTH * fontSize;
    return [UIFont systemFontOfSize:size];
}

@end
