//
//  SchedulerFootAddView.h
//  JieBao
//
//  Created by yangzhenmin on 2018/5/8.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SchedulerFootAddViewDelegate<NSObject>

- (void)addScheduleClicked;

@end

@interface SchedulerFootAddView : UIView

@property (nonatomic, weak) id<SchedulerFootAddViewDelegate>delegate;

@end
