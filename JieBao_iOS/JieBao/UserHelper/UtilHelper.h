//
//  UntilHelper.h
//  JieBao
//
//  Created by yangzhenmin on 2018/5/1.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ErrorModel.h"

@interface UtilHelper : NSObject

+ (id)fetchSSIDInfo;

+ (NSString *)getSSID;

+ (NSString *)md5:(NSString *)str;

+ (NSMutableArray<ErrorModel *> *)getErrorLists;

+ (void)setErrorList:(ErrorModel *)error;

+ (void)setWifiLocalize:(NSMutableDictionary *)wifi;

+ (NSMutableDictionary *)getWifi;

+ (BOOL) isValidateMobile:(NSString *)mobile;
@end
