//
//  UserHelper.h
//  JieBao
//
//  Created by yangzhenmin on 2018/4/12.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface UserHelper : NSObject

@property (nonatomic, copy) NSString *productSecretKey;

@property (nonatomic, strong) NSArray<GizWifiDevice *> *currentDevices;

+ (instancetype)shareInstance;

+ (UserModel *)getCurrentUser;

+ (void)setCurrentUser:(UserModel *)model;

@end
