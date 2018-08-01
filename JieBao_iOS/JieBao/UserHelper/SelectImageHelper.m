//
//  SelectImageHelper.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/27.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "SelectImageHelper.h"

@implementation SelectImageHelper

+ (UIImage *)selectImageWithTpye:(DeviceTpye)type
{
    if (DeviceTpyeNone == type) return nil;
    NSString *imgName = nil;
    switch (type) {
        case DeviceTpyeZaoLangBeng:
            imgName = @"1";
            break;
        case DeviceTpyeShuiBeng:
            imgName = @"3";
            break;
        case DeviceTpyeDianDiBeng:
            imgName = @"6";
            break;
        case DeviceTpyeCaiDeng:
            imgName = @"4";
            break;
        case DeviceTpyeKaiGuan:
            imgName = @"5";
            break;
        case DeviceTpyeAdd:
            imgName = @"tianjia2";
            break;
            
        default:
            break;
    }
    return [UIImage imageNamed:imgName];
}

+ (UIImage *)selectGroupImageWithTpye:(NSString *)type
{
    NSString *str = nil;
    if ([type isEqualToString:kProductKeys[@"六路彩灯"]]) {
        str = @"light_group";
    }else if ([type isEqualToString:kProductKeys[@"滴定泵"]]){
        str = @"fenzu5";
    }
    else if ([type isEqualToString:kProductKeys[@"无线开关"]]){
        str = @"fenzu4";
    }
    else if ([type isEqualToString:kProductKeys[@"造浪泵"]]){
        str = @"fenzu1";
    }
    else if ([type isEqualToString:kProductKeys[@"水泵"]]){
        str = @"fenzu2";
    }
    else
    {
        str = @"tianjiaBG";
    }
    return [UIImage imageNamed:str];
}

+ (UIImage *)selectGroupSelectedImageWithTpye:(NSString *)type
{
    NSString *str = nil;
    if ([type isEqualToString:kProductKeys[@"六路彩灯"]]) {
        str = @"light_groupSelected";
    }else if ([type isEqualToString:kProductKeys[@"滴定泵"]]){
        str = @"5fenzu";
    }
    else if ([type isEqualToString:kProductKeys[@"无线开关"]]){
        str = @"4fenzu";
    }
    else if ([type isEqualToString:kProductKeys[@"造浪泵"]]){
        str = @"1fenzu";
    }
    else if ([type isEqualToString:kProductKeys[@"水泵"]]){
        str = @"2fenzu";
    }
    else
    {
        str = @"tianjiaBG";
    }
    return [UIImage imageNamed:str];
}

+ (UIImage *)selectDeviceImageWithTpye:(NSString *)type
{
    NSString *str = nil;
    if ([type isEqualToString:kProductKeys[@"六路彩灯"]]) {
        str = @"light";
    }else if ([type isEqualToString:kProductKeys[@"滴定泵"]]){
        str = @"6";
    }
    else if ([type isEqualToString:kProductKeys[@"无线开关"]]){
        str = @"5";
    }
    else if ([type isEqualToString:kProductKeys[@"造浪泵"]]){
        str = @"1";
    }
    else if ([type isEqualToString:kProductKeys[@"水泵"]]){
        str = @"3";
    }
    else
    {
        str = @"tianjia2";
    }
    return [UIImage imageNamed:str];
}


+ (UIImage *)selectDeviceSelectedImageWithTpye:(NSString *)type
{
    NSString *str = nil;
    if ([type isEqualToString:kProductKeys[@"六路彩灯"]]) {
        str = @"light_selected";
    }else if ([type isEqualToString:kProductKeys[@"滴定泵"]]){
        str = @"66";
    }
    else if ([type isEqualToString:kProductKeys[@"无线开关"]]){
        str = @"55";
    }
    else if ([type isEqualToString:kProductKeys[@"造浪泵"]]){
        str = @"11";
    }
    else if ([type isEqualToString:kProductKeys[@"水泵"]]){
        str = @"33";
    }
    else
    {
        str = @"tianjia2";
    }
    return [UIImage imageNamed:str];
}

+ (UIImage *)selectDeviceNoConnectedWithTpye:(NSString *)type
{
    NSString *str = nil;
    if ([type isEqualToString:kProductKeys[@"六路彩灯"]]) {
        str = @"31";
    }else if ([type isEqualToString:kProductKeys[@"滴定泵"]]){
        str = @"42";
    }
    else if ([type isEqualToString:kProductKeys[@"无线开关"]]){
        str = @"52";
    }
    else if ([type isEqualToString:kProductKeys[@"造浪泵"]]){
        str = @"12";
    }
    else if ([type isEqualToString:kProductKeys[@"水泵"]]){
        str = @"22";
    }
    else
    {
        str = @"tianjia2";
    }
    return [UIImage imageNamed:str];
}


@end
