//
//  UserHelper.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/12.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "UserHelper.h"

static UserHelper *helper = nil;

@interface UserHelper()

@end

@implementation UserHelper

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[super allocWithZone:NULL] init];
    });
    return helper;
}


+ (UserModel *)getCurrentUser
{
    NSData *data = UserDefaultObject(kSynCurrentUserKey);
    UserModel *model = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    if (model) {
        return model;
    }else
    {
        return [UserModel new];
    }
}

+ (void)setCurrentUser:(UserModel *)model
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:model];
    SetUserDefaultObject(kSynCurrentUserKey, data);
}

@end
