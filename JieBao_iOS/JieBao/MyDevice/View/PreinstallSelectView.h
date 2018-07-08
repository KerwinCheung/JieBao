//
//  PreinstallSelectView.h
//  JieBao
//
//  Created by yangzhenmin on 2018/6/3.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PreinstallSelectViewDelegate<NSObject>

- (void)selectIndex:(NSInteger)index;

@end

@interface PreinstallSelectView : UIView

@property (nonatomic, weak) id<PreinstallSelectViewDelegate>delegate;

@end
