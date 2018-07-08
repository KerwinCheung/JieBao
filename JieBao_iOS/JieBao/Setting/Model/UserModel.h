//
//  UserModel.h
//  JieBao
//
//  Created by yangzhenmin on 2018/4/25.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject<NSCoding>

@property (nonatomic, copy) NSString *userName;

@property (nonatomic, copy) NSString *psw;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *token;

@end
