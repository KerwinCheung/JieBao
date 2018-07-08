//
//  DeviceCommonSchulder.h
//  JieBao
//
//  Created by yangzhenmin on 2018/6/21.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceCommonSchulder : NSObject

@property (nonatomic, copy) NSString *sid;

@property (nonatomic, copy) NSString *created_at;

@property (nonatomic, copy) NSString *product_key;

@property (nonatomic, copy) NSString *scene_id;

@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, copy) NSString *did;

@property (nonatomic, copy) NSString *raw;

@property (nonatomic, strong) NSDictionary *attrs;

@property (nonatomic, copy) NSString *date;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *repeat;

@property (nonatomic, copy) NSString *days;

@property (nonatomic, copy) NSString *start_date;

@property (nonatomic, copy) NSString *end_date;

@property (nonatomic, assign) BOOL enabled;

@property (nonatomic, copy) NSString *remark;

@end
