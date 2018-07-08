//
//  SettingHeadView.h
//  JieBao
//
//  Created by yangzhenmin on 2018/4/12.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingHeadViewDelegate<NSObject>

- (void)headImgTap;

@end

@interface SettingHeadView : UIView

@property (nonatomic, strong) UserModel *currentUser;

@property (nonatomic, weak) id<SettingHeadViewDelegate>delegate;

@end
