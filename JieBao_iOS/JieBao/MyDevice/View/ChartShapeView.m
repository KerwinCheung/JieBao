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
        self.imgs = @[@"write20",@"blue20",@"blue220",@"green20",@"red20",@"zi20"];
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

            CGFloat width = self.bounds.size.width;
            CGFloat cenX = ((CGFloat)(i)/24)*(width-CurrentDeviceSize(10));
            CGPoint point = CGPointMake(cenX, (CGFloat)(0.5*self.bounds.size.height));
            [self.points addObject:[NSValue valueWithCGPoint:point]];
            [self.schValues addObject:@((NSInteger)slider.value)];
        }
        
    }
    return self;
}

- (void)layoutSubviews
{
    if (self.count == 0 && self.bounds.size.width != 0) {
        for (int i = 0; i <24; i++) {
            LHWeakSelf(self)
            UISlider *slider = [self viewWithTag:100+i];
            slider.backgroundColor = [UIColor clearColor];
            CGFloat width = self.bounds.size.width;
            CGFloat cenX = ((CGFloat)(i)/24)*(width-CurrentDeviceSize(10));
            CGPoint point = CGPointMake(cenX, (1-((CGFloat)(slider.value/100)))*self.bounds.size.height);
            self.points[i] = [NSValue valueWithCGPoint:point];
            
            [slider mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(weakself.bounds.size.height + 2));
                make.height.equalTo(@(CurrentDeviceSize(6)));
                make.left.equalTo(@(cenX - ((CGFloat)(weakself.bounds.size.height/2))));
                make.centerY.equalTo(weakself.mas_centerY);
            }];
            
            slider.transform = CGAffineTransformMakeRotation(-M_PI_2);
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
    if (_delegate && [_delegate respondsToSelector:@selector(chartShapeViewValueChange:)]) {
        [_delegate chartShapeViewValueChange:(NSInteger)slider.value];
    }
    NSInteger index = slider.tag - 100;
    self.points[index] = [NSValue valueWithCGPoint:CGPointMake([self.points[index] CGPointValue].x, (1-((CGFloat)(slider.value/100)))*self.bounds.size.height)];
    self.schValues[index] = @((NSInteger)slider.value);
    [self setNeedsDisplay];
    LHLog(@"%f",slider.value);
}

- (void)drawRect:(CGRect)rect
{
    CGFloat width = self.bounds.size.width;
    CGPoint StartPoint25 = CGPointMake(0,0.75*self.bounds.size.height);
    CGPoint endPoint25   = CGPointMake(((CGFloat)(23)/24)*(width-CurrentDeviceSize(10)), 0.75*self.bounds.size.height);
    [self addDefaultLineWithStartPoint:StartPoint25 withEndPoint:endPoint25];
    
    CGPoint StartPoint75 = CGPointMake(0,0.25*self.bounds.size.height);
    CGPoint endPoint75   = CGPointMake(((CGFloat)(23)/24)*(width-CurrentDeviceSize(10)), 0.25*self.bounds.size.height);
    [self addDefaultLineWithStartPoint:StartPoint75 withEndPoint:endPoint75];
    
    
    CGPoint StartPoint50 = CGPointMake(0,0.5*self.bounds.size.height);
    CGPoint endPoint50   = CGPointMake(((CGFloat)(23)/24)*(width-CurrentDeviceSize(10)), 0.5*self.bounds.size.height);
    [self addDefaultLineWithStartPoint:StartPoint50 withEndPoint:endPoint50];
    
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


// 添加默认的线
-(void)addDefaultLineWithStartPoint:(CGPoint )startPoint withEndPoint:(CGPoint )endPoint{
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //创建路径
    CGMutablePathRef path =  CGPathCreateMutable();
    //设置起点
    CGPathMoveToPoint(path, NULL, startPoint.x, startPoint.y);
    //设置终点
    CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y);
    //颜色
    [UICOLORFROMRGB(0x69cef9) setStroke];
    //线宽
    CGContextSetLineWidth(ctx, 1);
    
    CGContextSetLineJoin(ctx, kCGLineJoinBevel);
    
    CGContextSetLineCap(ctx, kCGLineCapButt);
    
    CGContextAddPath(ctx, path);
    CGContextStrokePath(ctx);

}



- (void)setSchValues:(NSMutableArray<NSNumber *> *)schValues
{
    _schValues = [NSMutableArray arrayWithArray:schValues];
    for (int i = 0; i <24; i++) {
        UISlider *slider = [self viewWithTag:100+i];
        [slider setValue:[schValues[i] floatValue]];
        self.points[i] = [NSValue valueWithCGPoint:CGPointMake([self.points[i] CGPointValue].x, (1-((CGFloat)([schValues[i] floatValue]/100)))*self.bounds.size.height)];
       
    }
    [self setNeedsDisplay];
}

@end
