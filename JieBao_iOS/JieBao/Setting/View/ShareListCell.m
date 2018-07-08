//
//  ShareListCell.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/18.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "ShareListCell.h"

@interface ShareListCell()

@property (nonatomic, strong) UILabel *phoneLb;

@property (nonatomic, strong) UILabel *deviceNameLb;

@property (nonatomic, strong) UILabel *deviceMacLb;

@property (nonatomic, strong) UILabel *shareStateLb;

@end

@implementation ShareListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    [self.contentView addSubview:self.phoneLb];
    [self.contentView addSubview:self.deviceNameLb];
//    [self.contentView addSubview:self.deviceMacLb];
    [self.contentView addSubview:self.shareStateLb];
    
    [self makeContraints];
}

- (void)makeContraints
{
    LHWeakSelf(self)
    [self.phoneLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.top.equalTo(@(CurrentDeviceSize(5)));
        make.width.lessThanOrEqualTo(@(CurrentDeviceSize(200)));
    }];
    
    [self.deviceNameLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.phoneLb.mas_left);
        make.top.equalTo(weakself.phoneLb.mas_bottom).offset(CurrentDeviceSize(5));
        make.width.lessThanOrEqualTo(@(CurrentDeviceSize(200)));
        make.bottom.equalTo(weakself.contentView.mas_bottom).offset(-CurrentDeviceSize(5));
    }];
    
//    [self.deviceMacLb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(weakself.phoneLb.mas_left);
//        make.top.equalTo(weakself.deviceNameLb.mas_bottom).offset(CurrentDeviceSize(5));
//        make.width.lessThanOrEqualTo(@(CurrentDeviceSize(200)));
//        make.bottom.equalTo(weakself.contentView.mas_bottom).offset(-CurrentDeviceSize(5));
//    }];
    
    [self.shareStateLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.contentView.mas_right).offset(-CurrentDeviceSize(10));
        make.centerY.equalTo(weakself.contentView.mas_centerY);
        make.width.lessThanOrEqualTo(@(CurrentDeviceSize(100)));
    }];
}

- (UILabel *)phoneLb
{
    if (!_phoneLb) {
        _phoneLb = [UILabel new];
        _phoneLb.font = [UIFont sf_systemFontOfSize:13];
    }
    return _phoneLb;
}

- (UILabel *)deviceNameLb
{
    if (!_deviceNameLb) {
        _deviceNameLb = [UILabel new];
        _deviceNameLb.font = [UIFont sf_systemFontOfSize:13];
        _deviceNameLb.textColor = UICOLORFROMRGB(0x999999);
    }
    return _deviceNameLb;
}

- (UILabel *)deviceMacLb
{
    if (!_deviceMacLb) {
        _deviceMacLb = [UILabel new];
        _deviceMacLb.font = [UIFont sf_systemFontOfSize:13];
        _deviceMacLb.textColor = UICOLORFROMRGB(0x999999);
    }
    return _deviceMacLb;
}

- (UILabel *)shareStateLb
{
    if (!_shareStateLb) {
        _shareStateLb = [UILabel new];
        _shareStateLb.font = [UIFont sf_systemFontOfSize:13];
        _shareStateLb.textColor = kAPPThemeColor;
    }
    return _shareStateLb;
}

- (void)setDataDic:(ShareModel *)dataDic
{
    _dataDic = dataDic;
    self.phoneLb.text = dataDic.username;
    self.deviceNameLb.text = [NSString stringWithFormat:@"设备名: %@",dataDic.dev_alias];
//    self.deviceMacLb.text = [NSString stringWithFormat:@"设备Mac: %@",dataDic.did];
    NSString *str;
    if ([dataDic.status integerValue] == 0) {
        str = @"未接受分享";
    }else if ([dataDic.status integerValue] == 1){
        str = @"已接受分享";
    }
    else if ([dataDic.status integerValue] == 2){
        str = @"拒绝分享";
    }
    else if ([dataDic.status integerValue] == 3){
        str = @"取消分享";
    }
    self.shareStateLb.text = str;
}

@end
