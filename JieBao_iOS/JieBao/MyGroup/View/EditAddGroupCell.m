//
//  EditGroupCell.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/14.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "EditAddGroupCell.h"

@interface EditAddGroupCell()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *textLb;

@property (nonatomic, strong) UIImageView *tranferImgView;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation EditAddGroupCell

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
    [self.contentView addSubview:self.imgView];
    [self.contentView addSubview:self.textLb];
    [self.contentView addSubview:self.tranferImgView];
    [self.contentView addSubview:self.lineView];

    [self makeContraints];
}

- (void)makeContraints
{
    LHWeakSelf(self)
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakself).insets(UIEdgeInsetsZero);
    }];
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakself.mas_centerY);
        make.left.equalTo(@30);
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(30), CurrentDeviceSize(30)));
    }];
    
    [self.textLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakself.mas_centerY);
        make.left.equalTo(weakself.imgView.mas_right).offset(CurrentDeviceSize(10));
        make.width.lessThanOrEqualTo(@100);
    }];
    
    [self.tranferImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakself.bgView.mas_centerY);
        make.right.equalTo(weakself.bgView.mas_right).offset(-CurrentDeviceSize(20));
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(20), CurrentDeviceSize(10)));
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

- (UIImageView *)tranferImgView
{
    if (!_tranferImgView) {
        _tranferImgView = [UIImageView new];
        _tranferImgView.image = [UIImage imageNamed:@"yy"];
        _tranferImgView.hidden = YES;
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

- (void)setDataDic:(GizWifiDevice *)dataDic
{
    _dataDic = dataDic;
    self.imgView.image = [SelectImageHelper selectDeviceImageWithTpye:dataDic.productKey];
    if (dataDic.alias.length > 0) {
        self.textLb.text = dataDic.alias;
    }else{
        
        NSRange range = NSMakeRange(dataDic.macAddress.length - 7, 6);
        NSString *lastMacStr = [dataDic.macAddress substringWithRange:range];
        NSString *deaultStr = [NSString stringWithFormat:@"%@%@",[UtilHelper getDefaultNameStrPrefixWithProductKey:dataDic.productKey],lastMacStr];
        self.textLb.text = deaultStr ;
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
