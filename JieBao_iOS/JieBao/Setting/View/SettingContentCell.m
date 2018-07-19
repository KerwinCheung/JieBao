//
//  SettingContentCell.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/12.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "SettingContentCell.h"

@interface SettingContentCell()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *textLb;

@property (nonatomic, strong) UIImageView *tranferImgView;

@property (nonatomic, strong) UILabel *versionLb;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation SettingContentCell

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
    [self.bgView addSubview:self.imgView];
    [self.bgView addSubview:self.textLb];
    [self.bgView addSubview:self.tranferImgView];
    [self.bgView addSubview:self.lineView];
    [self.bgView addSubview:self.versionLb];

    [self makeContraints];
}

- (void)makeContraints
{
    LHWeakSelf(self)
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(@0);
        make.left.equalTo(@0);
        make.right.equalTo(@0);
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakself.mas_centerY);
        make.left.equalTo(@20);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.textLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakself.mas_centerY);
        make.left.equalTo(weakself.imgView.mas_right).offset(CurrentDeviceSize(20));
        make.width.lessThanOrEqualTo(@(CurrentDeviceSize(200)));
    }];
    
    [self.tranferImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakself.bgView.mas_centerY);
        make.right.equalTo(weakself.bgView.mas_right).offset(-20);
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(8), CurrentDeviceSize(14)));
    }];
    
    [self.versionLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakself.bgView.mas_centerY);
        make.right.equalTo(weakself.bgView.mas_right).offset(-20);
        make.width.lessThanOrEqualTo(@(CurrentDeviceSize(200)));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakself.mas_bottom);
        make.left.right.equalTo(@0);
        make.height.equalTo(@0.5);
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

- (UILabel *)versionLb
{
    if (!_versionLb) {
        _versionLb = [UILabel new];
        _versionLb.font = [UIFont sf_systemFontOfSize:13];
    }
    return _versionLb;
}

- (UIImageView *)tranferImgView
{
    if (!_tranferImgView) {
        _tranferImgView = [UIImageView new];
    }
    return _tranferImgView;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineView;
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
    self.tranferImgView.hidden = NO;
    self.versionLb.hidden = YES;
    self.imgView.image = [UIImage imageNamed:dataDic[kSettingImgKey]];
    self.textLb.text = dataDic[kSettingTextKey];
    self.tranferImgView.image = [UIImage imageNamed:dataDic[kSettingRightImgKey]?dataDic[kSettingRightImgKey]:@""];
}

- (void)setVersionStr:(NSString *)versionStr
{
    _versionStr = versionStr;
    self.tranferImgView.hidden = YES;
    self.versionLb.hidden = NO;
    self.versionLb.text = versionStr;
    self.versionLb.textColor = [UIColor lightGrayColor];
    
}
@end
