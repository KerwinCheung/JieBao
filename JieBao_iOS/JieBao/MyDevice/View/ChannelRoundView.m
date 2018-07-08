//
//  ChannelRoundView.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/23.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "ChannelRoundView.h"

@implementation ChannelRoundView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGFloat radius = rect.size.width/2;
    NSInteger count = rect.size.height/rect.size.width;
    [[UIColor greenColor] set];
    for (int i = 0; i < count; i++) {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path addArcWithCenter:CGPointMake(radius, (2*i+1)*radius) radius:radius startAngle:M_PI_2 endAngle:3*M_PI_2 clockwise:i%2 == 0 ? YES : NO];
        [path stroke];
    }
}

@end
