//
//  ChartShapeView.m
//  JieBao
//
//  Created by yangzhenmin on 2018/5/10.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "ChartShapeView.h"

@interface ChartShapeView()

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) UIColor *lineColor;

@property (nonatomic, strong) NSArray *colors;

@property (nonatomic, strong) NSArray *imgs;

@property (nonatomic, strong) NSMutableArray<NSValue *> *points;

@end

@implementation ChartShapeView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.lineColor = [UIColor blueColor];
        self.colors = @[[UIColor whiteColor],UICOLORFROMRGB(0x69cef9),[UIColor blueColor],[UIColor greenColor],[UIColor redColor],[UIColor purpleColor]];
        self.imgs = @[@"write",@"blue1",@"blue",@"green",@"red",@"zi"];
        UIView *vBorder = [UIView new];
        UIView *hBorder = [UIView new];
        vBorder.backgroundColor = hBorder.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:vBorder];
        [self addSubview:hBorder];
        self.points = [NSMutableArray array];
        _schValues = [NSMutableArray array];
        
        LHWeakSelf(self)
        [vBorder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(CurrentDeviceSize(1)));
            make.top.equalTo(@0);
            make.left.equalTo(@0);
            make.bottom.equalTo(weakself.mas_bottom);
        }];
        
        [hBorder mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(CurrentDeviceSize(1)));
            make.left.equalTo(@0);
            make.top.equalTo(vBorder.mas_bottom);
            make.right.equalTo(weakself.mas_right);
        }];
    }
    return self;
}

- (void)layoutSubviews
{
    if (self.count == 0 && self.bounds.size.width != 0) {
        for (int i = 0; i <24; i++) {
            UISlider *slider = [UISlider new];
            slider.tag = 100+i;
            slider.backgroundColor = [UIColor clearColor];
            slider.tintColor = [UIColor lightGrayColor];
            [slider setThumbImage:[UIImage imageNamed:self.imgs[0]] forState:UIControlStateNormal];
            [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
            slider.minimumValue = 0;
            slider.maximumValue = 100;
            slider.value = 50;

            [self addSubview:slider];
            
            LHWeakSelf(self)
            CGFloat width = self.bounds.size.width;
            CGFloat cenX = ((CGFloat)(i)/24)*(width-CurrentDeviceSize(10));
            CGPoint point = CGPointMake(cenX, (CGFloat)(0.5*self.bounds.size.height));
            [self.points addObject:[NSValue valueWithCGPoint:point]];
            
            [slider mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(weakself.bounds.size.height));
                make.height.equalTo(@(CurrentDeviceSize(4)));
                make.left.equalTo(@(cenX - ((CGFloat)(weakself.bounds.size.height/2))));
                make.centerY.equalTo(weakself.mas_centerY);
            }];
            
            slider.transform = CGAffineTransformMakeRotation(-M_PI_2);
        }
        
            if (self.schValues.count > 0) {
                for (int i = 0; i <24; i++) {
                    UISlider *slider = [self viewWithTag:100+i];
                    [slider setValue:[self.schValues[i] floatValue]];
                    self.points[i] = [NSValue valueWithCGPoint:CGPointMake([self.points[i] CGPointValue].x, (1-((CGFloat)([self.schValues[i] floatValue]/100)))*self.bounds.size.height)];
                }
            }else{
                for (int i = 0; i <24; i++) {
                    UISlider *slider = [self viewWithTag:100+i];
                    [self.schValues addObject:@((NSInteger)slider.value)];
                }
            }
        
        self.count = 1;
        [self setNeedsDisplay];
    }
}

- (void)setTrackAndLineColorWithIndex:(NSInteger)index
{
    self.lineColor = self.colors[index];
    for (int i = 0; i <24; i++) {
        UISlider *slider = [self viewWithTag:100+i];
        [slider setThumbImage:[UIImage imageNamed:self.imgs[index]] forState:UIControlStateNormal];
    }
    [self setNeedsDisplay];
}

- (void)sliderValueChanged:(UISlider *)slider
{
    NSInteger index = slider.tag - 100;
    self.points[index] = [NSValue valueWithCGPoint:CGPointMake([self.points[index] CGPointValue].x, (1-((CGFloat)(slider.value/100)))*self.bounds.size.height)];
    self.schValues[index] = @((NSInteger)slider.value);
    [self setNeedsDisplay];
    LHLog(@"%f",slider.value);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    if (self.points.count == 0) return;
    [self.lineColor set];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake([self.points[0] CGPointValue].x, [self.points[0] CGPointValue].y)];
    for (int i=1; i<self.points.count; i++) {
        [path addLineToPoint:CGPointMake([self.points[i] CGPointValue].x, [self.points[i] CGPointValue].y)];
    }
    [path stroke];
    CGContextAddPath(ctx, path.CGPath);
}

- (void)setSchValues:(NSMutableArray<NSNumber *> *)schValues
{
    _schValues = schValues;
    for (int i = 0; i <24; i++) {
        UISlider *slider = [self viewWithTag:100+i];
        [slider setValue:[schValues[i] floatValue]];
        self.points[i] = [NSValue valueWithCGPoint:CGPointMake([self.points[i] CGPointValue].x, (1-((CGFloat)([schValues[i] floatValue]/100)))*self.bounds.size.height)];
    }
    [self setNeedsDisplay];
}



@end
