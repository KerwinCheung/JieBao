//
//  ShareListCell.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/18.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "ChannelDetailCell.h"

@interface ChannelDetailCell()

@property (nonatomic, strong) UILabel *addNumLb;

@property (nonatomic, strong) UILabel *addTimeLb;

@property (nonatomic, strong) UIButton *tranferImgBtn;

@end

@implementation ChannelDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    [self.contentView addSubview:self.addNumLb];
    [self.contentView addSubview:self.addNumLb];
    [self.contentView addSubview:self.tranferImgBtn];
    
    [self makeContraints];
}

- (void)makeContraints
{
    LHWeakSelf(self)
    
    [self.addNumLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.top.equalTo(@(CurrentDeviceSize(5)));
        make.width.lessThanOrEqualTo(@(CurrentDeviceSize(200)));
    }];
    
    [self.addTimeLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.addNumLb.mas_left);
        make.top.equalTo(weakself.addNumLb.mas_bottom).offset(CurrentDeviceSize(5));
        make.width.lessThanOrEqualTo(@(CurrentDeviceSize(200)));
        make.bottom.equalTo(weakself.contentView.mas_bottom).offset(-CurrentDeviceSize(5));
    }];
    
    [self.tranferImgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakself.contentView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(20), CurrentDeviceSize(20)));
        make.width.equalTo(weakself.contentView.mas_right).offset(-CurrentDeviceSize(20));
    }];
    
}

- (void)tranferImgBtnClicked
{
    if (_delegate && [_delegate respondsToSelector:@selector(tranferToSetChannelTime)]) {
        [_delegate tranferToSetChannelTime];
    }
}


- (UILabel *)addNumLb
{
    if (!_addNumLb) {
        _addNumLb = [UILabel new];
        _addNumLb.font = [UIFont sf_systemFontOfSize:13];
        _addNumLb.textColor = UICOLORFROMRGB(0x999999);
    }
    return _addNumLb;
}

- (UILabel *)addTimeLb
{
    if (!_addTimeLb) {
        _addTimeLb = [UILabel new];
        _addTimeLb.font = [UIFont sf_systemFontOfSize:13];
        _addTimeLb.textColor = UICOLORFROMRGB(0x999999);
    }
    return _addTimeLb;
}

- (UIButton *)tranferImgBtn
{
    if (!_tranferImgBtn) {
        _tranferImgBtn = [UIButton new];
        [_tranferImgBtn setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
        [_tranferImgBtn addTarget:self action:@selector(tranferImgBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tranferImgBtn;
}


- (void)setDataDic:(GizDeviceScheduler *)dataDic
{
    _dataDic = dataDic;
    self.addNumLb.text = [NSString stringWithFormat:@"补给量: %@",dataDic.attrs.allValues.firstObject];
    self.addTimeLb.text = [NSString stringWithFormat:@"补给时间: %@",dataDic.time];
}

@end
