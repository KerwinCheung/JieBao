//
//  LightControlView.h
//  JieBao
//
//  Created by yangzhenmin on 2018/5/9.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LightControlViewDelegate<NSObject>

- (void)colorBlockClicked:(id)view;

@end


@interface LightControlView : UIView

@property (nonatomic, weak) id<LightControlViewDelegate>delegate;

@property (nonatomic, strong) UIColor *btnColor;

@property (nonatomic, assign) NSInteger value;

@property (nonatomic, assign) BOOL isClicked;

@end
