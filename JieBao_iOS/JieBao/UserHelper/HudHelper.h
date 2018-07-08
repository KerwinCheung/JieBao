//
//  HudHelper.h
//  JieBao
//
//  Created by yangzhenmin on 2018/6/23.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HudHelper : NSObject

+ (void)showStatus:(NSString *)status;

+ (void)showStatus:(NSString *)status dismiss:(NSInteger)time;

+ (void)showErrorWithStatus:(NSString *)status;

+ (void)showSuccessWithStatus:(NSString *)status;

+ (void)showInfoWithStatus:(NSString *)status;

+ (void)show;

+ (void)dismiss;
@end
