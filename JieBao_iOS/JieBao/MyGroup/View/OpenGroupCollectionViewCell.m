//
//  DeviceCollectionViewCell.m
//  JieBao
//
//  Created by yangzhenmin on 2018/6/6.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "OpenGroupCollectionViewCell.h"

@interface OpenGroupCollectionViewCell()

@property (nonatomic, strong) UIImageView *img;

@property (nonatomic, strong) UILabel *lb;

@property (nonatomic, assign) BOOL clicked;

@end

@implementation OpenGroupCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        [self.contentView addSubview:self.img];
        [self.contentView addSubview:self.lb];
        
        LHWeakSelf(self)
        [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(@0);
            make.size.mas_equalTo(CGSizeMake(2*perWidth, 2*perWidth));
        }];
        
        [self.lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakself.img.mas_centerX);
            make.top.equalTo(weakself.img.mas_bottom).offset(CurrentDeviceSize(5));
            make.width.lessThanOrEqualTo(@100);
        }];
    }
    return self;
}

- (void)cellSetSelected
{
    self.clicked = !self.clicked;
    if (self.clicked) {
        self.img.image = [SelectImageHelper selectDeviceSelectedImageWithTpye:self.dataDic.product_key];
    }else
    {
        self.img.image = [SelectImageHelper selectDeviceImageWithTpye:self.dataDic.product_key];
    }
}

- (BOOL)isSwitchOn
{
    return self.clicked;
}

- (UILabel *)lb
{
    if (!_lb) {
        _lb = [UILabel new];
        _lb.font = [UIFont sf_systemFontOfSize:13];
        _lb.adjustsFontSizeToFitWidth = YES;
        _lb.textAlignment = NSTextAlignmentCenter;
    }
    return _lb;
}

- (UIImageView *)img
{
    if (!_img) {
        _img = [UIImageView new];
    }
    return _img;
}

- (void)setDataDic:(CustomDevice *)dataDic
{
    _dataDic = dataDic;
    self.img.image = [SelectImageHelper selectDeviceImageWithTpye:dataDic.product_key];
    self.lb.text = dataDic.verbose_name;
}
@end
