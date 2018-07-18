//
//  UIview+Extension.m
//  LvTaotao
//
//  Created by XMYY-21 on 2018/4/24.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "UIview+Extension.h"


@implementation UIView (Extension)

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (CGFloat)MaxX
{
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)MaxY
{
    return CGRectGetMaxY(self.frame);
}

- (CGFloat)MinX {
    return CGRectGetMinX(self.frame);
}

- (CGFloat)MinY {
    return CGRectGetMinY(self.frame);
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)centerY
{
    return self.center.y;
}



/** 水平居中 */
- (void)alignHorizontal
{
    self.x = (self.superview.width - self.width) * 0.5;
}

/** 垂直居中 */
- (void)alignVertical
{
    self.y = (self.superview.height - self.height) * 0.5;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@dynamic borderColor,borderWidth,cornerRadius;

- (void)setBorderColor:(UIColor *)borderColor {
    [self.layer setBorderColor:borderColor.CGColor];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    [self.layer setBorderWidth:borderWidth];
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    [self.layer setCornerRadius:cornerRadius];
}

- (void)setShadowColor:(UIColor *)shadowColor {
    self.layer.shadowColor = shadowColor.CGColor;
}

- (void)setShadowOpacity:(CGFloat)shadowOpacity {
    self.layer.shadowOpacity = shadowOpacity;
}

- (void)setShadowRadius:(CGFloat)shadowRadius {
    self.layer.shadowRadius = shadowRadius;
}

- (void)setShadowOffset:(CGSize)shadowOffset {
    self.layer.shadowOffset = shadowOffset;
}

- (void)setLayerBackgroundColor:(UIColor *)layerBackgroundColor {
    self.layer.backgroundColor = layerBackgroundColor.CGColor;
}

- (void)addSubviewWithStretch:(UIView *)view {
    [self addSubview:view];
    
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0];
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:0];
    [self addConstraints:@[constraint1, constraint2, constraint3, constraint4]];
}

- (void)addSubview:(UIView *)view edgeInsets:(UIEdgeInsets *)edgeInsets {
    [self addSubview:view];
    
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *constraint1 = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:edgeInsets->top];
    NSLayoutConstraint *constraint2 = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:edgeInsets->left];
    NSLayoutConstraint *constraint3 = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:edgeInsets->bottom];
    NSLayoutConstraint *constraint4 = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1.0 constant:edgeInsets->right];
    [self addConstraints:@[constraint1, constraint2, constraint3, constraint4]];
}

- (void)setBorderRadius:(CGFloat)borderRadius {
    [[NSOperationQueue new] addOperationWithBlock:^{
        CGFloat width = self.width;
        CGFloat height = self.height;
        
        CGMutablePathRef pathRef = CGPathCreateMutable();
        
        CGPathMoveToPoint(pathRef, nil, 0, 0);
        CGPathAddArcToPoint(pathRef, nil, width, 0, width, height, 100);
        CGPathAddArcToPoint(pathRef, nil, width, height, 0, height, 100);
        CGPathAddArcToPoint(pathRef, nil, 0, height, 0, 10, 40);
        CGPathAddArcToPoint(pathRef, nil, 0, 15, 15, 15, 5);
        CGPathAddArcToPoint(pathRef, nil, 15, 15, 15, 0, 10);
        CGPathAddArcToPoint(pathRef, nil, 15, 0, 20, 0, 5);
        CGPathCloseSubpath(pathRef);
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            CAShapeLayer *layer = [CAShapeLayer layer];
            layer.path = pathRef;
            self.layer.mask = layer;
            CGPathRelease(pathRef);
        }];
    }];
}

+ (instancetype)viewFromXIBWithOwner:(nullable id)owner {
   return [[[NSBundle bundleForClass:self.class] loadNibNamed:NSStringFromClass(self.class) owner:owner options:nil] firstObject];
}

+ (instancetype)viewFromXIBWithOwner:(nullable id)owner frame:(CGRect)frame {
    UIView * view = [self viewFromXIBWithOwner:owner];
    view.frame = frame;
    return view;
}

@end

