//
//  NetworkHelper.h
//  JieBao
//
//  Created by yangzhenmin on 2018/6/5.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^NetWorkCallBack)(NSData *data,NSError *error);

@interface NetworkHelper : NSObject

+ (void)sendRequest:(NSDictionary *)body Method:(NSString *)method Path:(NSString *)path callback:(NetWorkCallBack)callback;

@end
