//
//  SliderView.h
//  JieBao
//
//  Created by yangzhenmin on 2018/4/23.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SliderView : UIView

@property (nonatomic, assign) CGFloat value;

@property (nonatomic, copy) NSString *title;

- (void)setTrickColor:(UIColor *)color;

- (void)setTrickImg:(NSString *)img;

@end
