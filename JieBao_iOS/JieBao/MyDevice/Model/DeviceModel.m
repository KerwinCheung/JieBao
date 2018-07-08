//
//  DeviceModel.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/26.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "DeviceModel.h"

@implementation DeviceModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.deviceName = [aDecoder decodeObjectForKey:@"deviceName"];
        self.type = [[aDecoder decodeObjectForKey:@"type"] integerValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.deviceName forKey:@"deviceName"];
    [aCoder encodeObject:@(self.type) forKey:@"type"];
}

@end
