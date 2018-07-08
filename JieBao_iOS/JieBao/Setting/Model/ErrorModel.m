//
//  ErrorModel.m
//  JieBao
//
//  Created by yangzhenmin on 2018/6/12.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "ErrorModel.h"

@implementation ErrorModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.deviceName = [aDecoder decodeObjectForKey:@"deviceName"];
        self.errorName = [aDecoder decodeObjectForKey:@"errorName"];
        self.time = [aDecoder decodeObjectForKey:@"time"];
        self.prodeuctKey = [aDecoder decodeObjectForKey:@"prodeuctKey"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.deviceName forKey:@"deviceName"];
    [aCoder encodeObject:self.errorName forKey:@"errorName"];
    [aCoder encodeObject:self.time forKey:@"time"];
    [aCoder encodeObject:self.prodeuctKey forKey:@"prodeuctKey"];
}


@end
