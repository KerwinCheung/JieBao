//
//  MyDeviceNoDeviceView.h
//  JieBao
//
//  Created by yangzhenmin on 2018/4/27.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyDeviceNoDeviceViewDelegate<NSObject>

- (void)addBtnClicked;

@end

@interface MyDeviceNoDeviceView : UIView

@property (nonatomic, weak) id<MyDeviceNoDeviceViewDelegate>delegate;

@end
