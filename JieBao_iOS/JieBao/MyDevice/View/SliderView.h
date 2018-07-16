//
//  SliderView.h
//  JieBao
//
//  Created by yangzhenmin on 2018/4/23.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SliderView;
@protocol SliderViewDelegate<NSObject>

- (void)SliderViewChanged:(float)value withSliderView:(SliderView *)sliderView;

@end

@interface SliderView : UIView

@property (nonatomic, assign)id<SliderViewDelegate>delegate;
@property (nonatomic, assign) CGFloat value;

@property (nonatomic, copy) NSString *title;

- (void)setTrickColor:(UIColor *)color;

- (void)setTrickImg:(NSString *)img;

@end
