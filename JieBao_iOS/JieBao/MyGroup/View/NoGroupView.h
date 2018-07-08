//
//  MyDeviceNoGroupView.h
//  JieBao
//
//  Created by yangzhenmin on 2018/4/27.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoGroupViewDelegate<NSObject>

- (void)addBtnClicked;

@end

@interface NoGroupView : UIView

@property (nonatomic, weak) id<NoGroupViewDelegate>delegate;

@end
