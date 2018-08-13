//
//  ShareListCell.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/18.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "ShareListCell.h"

@interface ShareListCell()

@end

@implementation ShareListCell


-(void)setShareModel:(ShareModel *)shareModel{
    _shareModel = shareModel;
    self.phoneLabel.text = shareModel.phone;
    NSString *currentLanguage = [UtilHelper getCurrentLanguage];

    if (shareModel.dev_alias.length >0) {
        if ([currentLanguage containsString:@"zh"]) {
            self.devNameLabel.text = [NSString stringWithFormat:@"设备名:%@",shareModel.dev_alias];
        }else{
            self.devNameLabel.text = [NSString stringWithFormat:@"The device Name:%@",shareModel.dev_alias];
        }
        
    }else{
        GizWifiDevice *device ;
        for (GizWifiDevice *dev in SDKHELPER.deviceArray) {
            if ([dev.did isEqualToString:shareModel.did]) {
                device = dev;
                break;
            }
        }
        NSRange range = NSMakeRange(device.macAddress.length - 6, 6);
        NSString *lastMacStr = [device.macAddress substringWithRange:range];
        NSString *deaultStr = [NSString stringWithFormat:@"%@%@",[UtilHelper getDefaultNameStrPrefixWithProductKey:device.productKey],lastMacStr];
        
        if ([currentLanguage containsString:@"zh"]) {
            self.devNameLabel.text = [NSString stringWithFormat:@"设备名:%@",deaultStr];
        }else{
            self.devNameLabel.text = [NSString stringWithFormat:@"The device Name:%@",deaultStr];
        }
        
        
    }
    for (GizWifiDevice *dev in SDKHELPER.deviceArray) {
        if ([dev.did isEqualToString:shareModel.did]) {
            
            if ([currentLanguage containsString:@"zh"]) {
                self.macLabel.text = [NSString stringWithFormat:@"设备Mac: %@",dev.macAddress];
            }else{
                self.macLabel.text = [NSString stringWithFormat:@"The device Mac: %@",dev.macAddress];
            }
            
            break;
        }
    }
    
    NSString *str;
    if ([shareModel.status integerValue] == 0) {
        str = @"未接受分享";
    }else if ([shareModel.status integerValue] == 1){
        str = @"已接受分享";
    }
    else if ([shareModel.status integerValue] == 2){
        str = @"拒绝分享";
    }
    else if ([shareModel.status integerValue] == 3){
        str = @"取消分享";
    }
    self.statusLabel.text = str;
}





@end
