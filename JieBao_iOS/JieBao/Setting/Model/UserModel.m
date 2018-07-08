//
//  UserModel.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/25.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.userName = [aDecoder decodeObjectForKey:@"userName"];
        self.psw = [aDecoder decodeObjectForKey:@"psw"];
        self.uid = [aDecoder decodeObjectForKey:@"uid"];
        self.token = [aDecoder decodeObjectForKey:@"token"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.userName forKey:@"userName"];
    [aCoder encodeObject:self.psw forKey:@"psw"];
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.token forKey:@"token"];
}



@end
