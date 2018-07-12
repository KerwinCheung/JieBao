//
//  EditGroupCell.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/14.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "EditGroupCell.h"

@interface EditGroupCell()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *textLb;

@property (nonatomic, strong) UIImageView *tranferImgView;

@end

@implementation EditGroupCell

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
    [self addSubview:self.bgView];
//    [self.bgView addSubview:self.imgView];
    [self.bgView addSubview:self.textLb];
    [self.bgView addSubview:self.tranferImgView];
    
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
    
//    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(weakself.mas_centerY);
//        make.left.equalTo(@(CurrentDeviceSize(20)));
//        make.size.mas_equalTo(CGSizeMake(20, 20));
//    }];
    
    [self.textLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakself.mas_centerY);
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.width.lessThanOrEqualTo(@100);
    }];
    
    [self.tranferImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakself.bgView.mas_centerY);
        make.right.equalTo(weakself.bgView.mas_right).offset(-CurrentDeviceSize(20));
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(10), CurrentDeviceSize(20)));
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
    }
    return _tranferImgView;
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [UIView new];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

- (void)setDataDic:(NSDictionary *)dataDic
{
    _dataDic = dataDic;
    self.imgView.image = [UIImage imageNamed:dataDic[kSettingImgKey]];
    self.tranferImgView.image = [UIImage imageNamed:dataDic[kSettingRightImgKey]?dataDic[kSettingRightImgKey]:@""];
    self.textLb.text = dataDic[kSettingTextKey];
}


@end

