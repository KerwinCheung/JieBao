
//
//  UIview+Extension.h
//  LvTaotao
//
//  Created by XMYY-21 on 2018/4/24.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger, SteHubType) {
    SteHubTypeOnlyMessage = 0,
    SteHubTypeOnlyIndicator = 1,
    SteHubTypeIndicatorAndMessage = 2,
};

IB_DESIGNABLE
@interface UIView (Extension)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign,readonly) CGFloat MaxX;
@property (nonatomic, assign,readonly) CGFloat MaxY;
@property (nonatomic, assign,readonly) CGFloat MinX;
@property (nonatomic, assign,readonly) CGFloat MinY;

@property (nonatomic) IBInspectable UIColor *borderColor;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable CGFloat cornerRadius;

@property (nonatomic) IBInspectable UIColor *shadowColor;
@property (nonatomic) IBInspectable CGFloat shadowOpacity;
@property (nonatomic) IBInspectable CGFloat shadowRadius;
@property (nonatomic) IBInspectable CGSize shadowOffset;

@property (nonatomic) IBInspectable CGFloat borderRadius;
@property (nonatomic) IBInspectable UIColor* layerBackgroundColor;

// AutoLayout，四边constraint为0。
- (void)addSubviewWithStretch:(UIView *)view;
- (void)addSubview:(UIView *)view edgeInsets:(UIEdgeInsets *)edgeInsets;

///类初始化加载xib
+ (instancetype)viewFromXIBWithOwner:(nullable id)owner;
+ (instancetype)viewFromXIBWithOwner:(nullable id)owner frame:(CGRect)frame;

@end
