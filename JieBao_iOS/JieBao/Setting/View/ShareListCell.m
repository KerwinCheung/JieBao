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
    self.devNameLabel.text = [NSString stringWithFormat:@"设备名: %@",shareModel.dev_alias];
    for (GizWifiDevice *dev in SDKHELPER.deviceArray) {
        if ([dev.did isEqualToString:shareModel.did]) {
            self.macLabel.text = [NSString stringWithFormat:@"设备Mac: %@",dev.macAddress];
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
