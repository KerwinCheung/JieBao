//
//  BaseSlider.m
//  JieBao
//
//  Created by yangzhenmin on 2018/6/8.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "BaseSlider.h"

@implementation BaseSlider

// 控制slider的宽和高，这个方法才是真正的改变slider滑道的高的
- (CGRect)trackRectForBounds:(CGRect)bounds
{
    return CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
}

@end
