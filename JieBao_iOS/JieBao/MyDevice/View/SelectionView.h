//
//  SelectionView.h
//  JieBao
//
//  Created by yangzhenmin on 2018/5/16.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectionViewDelegate<NSObject>

- (void)transferBtnClicked:(id)obj;

@end

@interface SelectionView : UIView

@property (nonatomic, weak)id<SelectionViewDelegate>delegate;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *subTitle;

@property (nonatomic, assign) BOOL transferHidden;

@end
