//
//  ErrorModel.h
//  JieBao
//
//  Created by yangzhenmin on 2018/6/12.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ErrorModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *prodeuctKey;

@property (nonatomic, copy) NSString *deviceName;

@property (nonatomic, copy) NSString *errorName;

@property (nonatomic, copy) NSString *time;

@end
