//
//  ErrorListCell.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/18.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "ErrorListCell.h"

@interface ErrorListCell ()

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *subLb;

@property (nonatomic, strong) UILabel *errorLb;

@property (nonatomic, strong) UILabel *dateLb;

@property (nonatomic, strong) UIView *sepLine;

@end

@implementation ErrorListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.subLb];
    [self.contentView addSubview:self.errorLb];
    [self.contentView addSubview:self.dateLb];
    [self.contentView addSubview:self.sepLine];
    
    [self makeContraints];
}

- (void)makeContraints
{
    LHWeakSelf(self)
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakself.contentView.mas_centerY);
        make.top.equalTo(@(CurrentDeviceSize(20)));
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(40), CurrentDeviceSize(40)));
    }];
    
    [self.subLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.imgView.mas_right).offset(CurrentDeviceSize(10));
        make.top.equalTo(@(CurrentDeviceSize(10)));
        make.width.lessThanOrEqualTo(@200);
    }];
    
    [self.errorLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakself.contentView);
        make.right.equalTo(weakself.contentView.mas_right).offset(-CurrentDeviceSize(10));
        make.width.lessThanOrEqualTo(@200);
    }];
    
    [self.dateLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.subLb.mas_left);
        make.top.equalTo(weakself.subLb.mas_bottom).offset(CurrentDeviceSize(10));
        make.width.lessThanOrEqualTo(@200);
        make.bottom.equalTo(weakself.contentView.mas_bottom).offset(-CurrentDeviceSize(10));
    }];
    
    [self.sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.left.equalTo(@(CurrentDeviceSize(10)));
        make.right.equalTo(weakself.contentView.mas_right).offset(-CurrentDeviceSize(10));
        make.height.equalTo(@(CurrentDeviceSize(0.5)));
    }];
}

- (UILabel *)subLb
{
    if (!_subLb) {
        _subLb = [UILabel new];
        _subLb.font = [UIFont sf_systemFontOfSize:13];
    }
    return _subLb;
}

- (UILabel *)errorLb
{
    if (!_errorLb) {
        _errorLb = [UILabel new];
        _errorLb.font = [UIFont sf_systemFontOfSize:13];
    }
    return _errorLb;
}

- (UILabel *)dateLb
{
    if (!_dateLb) {
        _dateLb = [UILabel new];
        _dateLb.font = [UIFont sf_systemFontOfSize:13];
    }
    return _dateLb;
}

- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [UIImageView new];
    }
    return _imgView;
}

- (UIView *)sepLine
{
    if (!_sepLine) {
        _sepLine = [UIView new];
        _sepLine.backgroundColor = [UIColor lightGrayColor];
    }
    return _sepLine;
}

- (void)setDataDic:(ErrorModel *)dataDic
{
    self.subLb.text = dataDic.deviceName;
    self.errorLb.text = [NSString stringWithFormat:@"%@-故障",dataDic.errorName];
    self.dateLb.text = dataDic.time;
    self.imgView.image = [SelectImageHelper selectDeviceImageWithTpye:dataDic.prodeuctKey];
}
@end
