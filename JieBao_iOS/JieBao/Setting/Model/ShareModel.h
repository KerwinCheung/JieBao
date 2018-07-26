//
//  ShareModel.h
//  JieBao
//
//  Created by yangzhenmin on 2018/6/11.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareModel : NSObject

/**分享记录id*/
@property (nonatomic, copy) NSString *sid;

/**
 分享类型，0：普通分享，1：二维码分享
 */
@property (nonatomic, copy) NSString *type;
/**
 用户ID
 */
@property (nonatomic, copy) NSString *uid;

/**
 用户名,中间4个字母*替代
 */
@property (nonatomic, copy) NSString *username;

/**
 用户别名
 */
@property (nonatomic, copy) NSString *user_alias;

/**
 用户邮箱地址,@前面4个字符*替代
 */
@property (nonatomic, copy) NSString *email;

/**
 用户手机号码,中间4个数字*替代
 */
@property (nonatomic, copy) NSString *phone;

/**
 设备id
 */
@property (nonatomic, copy) NSString *did;

/**
 产品名称
 */
@property (nonatomic, copy) NSString *product_name;

/**
 设备别名
 */
@property (nonatomic, copy) NSString *dev_alias;

/**
 当前分享状态 0：未接受分享，1：已接受分享，2：拒绝分享，3：取消分享
 */
@property (nonatomic, copy) NSString *status;

/**
 创建分享时间 （UTC时间）
 */
@property (nonatomic, copy) NSString *created_at;
/**
 分享状态更新时间 （UTC时间）
 */
@property (nonatomic, copy) NSString *updated_at;

/**
 分享超时时间 （UTC时间）
 */
@property (nonatomic, copy) NSString *expired_at;


@end
