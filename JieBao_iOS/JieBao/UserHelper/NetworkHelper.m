//
//  NetworkHelper.m
//  JieBao
//
//  Created by yangzhenmin on 2018/6/5.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "NetworkHelper.h"

@implementation NetworkHelper


+ (void)sendRequest:(NSDictionary *)body Method:(NSString *)method Path:(NSString *)path callback:(NetWorkCallBack)callback;
{
    NSString *appid = kAppId;
    NSString *token = [UserHelper getCurrentUser].token;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:path]];
    if (body) {
        NSData *bodyData = [NSJSONSerialization dataWithJSONObject:body options:NSJSONWritingPrettyPrinted error:nil];
        [request setHTTPBody:bodyData];
    }
    [request setValue:appid forHTTPHeaderField:@"X-Gizwits-Application-Id"];
    [request setValue:token forHTTPHeaderField:@"X-Gizwits-User-token"];
    [request setHTTPMethod:method];
    [request setTimeoutInterval:10.0];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (callback) {
            callback(data,error);
        }
    }];
    [task resume];
}

@end
