//
//  EditGroupCell.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/14.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "GroupEditCell.h"

@interface GroupEditCell()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *textLb;

@property (nonatomic, strong) UIImageView *tranferImgView;

@end

@implementation GroupEditCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.imgView];
    [self.bgView addSubview:self.textLb];
    [self.bgView addSubview:self.tranferImgView];
    self.backgroundColor = [UIColor whiteColor];
    
    [self makeContraints];
}

- (void)makeContraints
{
    LHWeakSelf(self)
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(weakself.mas_right);
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakself.mas_centerY);
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.textLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakself.mas_centerY);
        make.left.equalTo(weakself.imgView.mas_right).offset(CurrentDeviceSize(10));
        make.width.lessThanOrEqualTo(@100);
    }];
    
    [self.tranferImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakself.bgView.mas_centerY);
        make.right.equalTo(weakself.bgView.mas_right).offset(-CurrentDeviceSize(20));
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(20), CurrentDeviceSize(20)));
    }];
}


- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [UIImageView new];
    }
    return _imgView;
}

- (UILabel *)textLb
{
    if (!_textLb) {
        _textLb = [UILabel new];
        _textLb.font = [UIFont sf_systemFontOfSize:13];
    }
    return _textLb;
}

- (UIImageView *)tranferImgView
{
    if (!_tranferImgView) {
        _tranferImgView = [UIImageView new];
        _tranferImgView.image = [UIImage imageNamed:@"yy"];
        _tranferImgView.hidden = YES;
    }
    return _tranferImgView;
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [UIView new];
//        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (void)setDataDic:(CustomDevice *)dataDic
{
    _dataDic = dataDic;
    self.imgView.image = [SelectImageHelper selectDeviceImageWithTpye:dataDic.product_key];
    for (GizWifiDevice *dev in SDKHELPER.deviceArray) {
        if ([dev.did isEqualToString:dataDic.did]) {
            if (dev.alias.length > 0) {
                self.textLb.text = dev.alias;
            }else{
                self.textLb.text = dev.productName;
            }
            break;
        }
    }

}

- (void)setSelected
{
    self.tranferImgView.hidden = !self.tranferImgView.hidden;
}

- (BOOL)getSelected
{
    return !self.tranferImgView.hidden;
}
@end

