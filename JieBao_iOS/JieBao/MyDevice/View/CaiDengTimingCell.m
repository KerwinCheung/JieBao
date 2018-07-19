//
//  EditGroupCell.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/14.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "CaiDengTimingCell.h"

@interface CaiDengTimingCell()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UILabel *textLb;

@property (nonatomic, strong) UIImageView *tranferImgView;

@property (nonatomic, strong) UIImageView *selectImgView;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation CaiDengTimingCell

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
    [self.contentView addSubview:self.selectImgView];
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
        make.left.equalTo(@(CurrentDeviceSize(10)));
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(20), CurrentDeviceSize(22)));
    }];
    
    [self.textLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakself.mas_centerY);
        make.left.equalTo(weakself.imgView.mas_right).offset(CurrentDeviceSize(10));
        make.width.lessThanOrEqualTo(@100);
    }];
    
    [self.tranferImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakself.bgView.mas_centerY);
        make.right.equalTo(weakself.bgView.mas_right).offset(-CurrentDeviceSize(20));
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(8), CurrentDeviceSize(14)));
    }];
    
    [self.selectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakself.bgView.mas_centerY);
        make.right.equalTo(weakself.bgView.mas_right).offset(-CurrentDeviceSize(20));
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(20), CurrentDeviceSize(20)));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(weakself.mas_bottom);
        make.left.right.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
}

- (void)setSelected
{
    self.selectImgView.hidden = !self.selectImgView.hidden;
}

- (BOOL)getSelected
{
    return !self.selectImgView.hidden;
}

- (void)setSelectedWithStutas:(BOOL)status
{
    self.selectImgView.hidden = !status;
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
        _tranferImgView.image = [UIImage imageNamed:@"next"];
        _tranferImgView.hidden = YES;
    }
    return _tranferImgView;
}

- (UIImageView *)selectImgView
{
    if (!_selectImgView) {
        _selectImgView = [UIImageView new];
        _selectImgView.image = [UIImage imageNamed:@"yy"];
        _selectImgView.hidden = YES;
    }
    return _selectImgView;
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

- (void)setDataDic:(DeviceSchedulerTask *)dataDic
{
    _dataDic = dataDic;
    self.imgView.image = [UIImage imageNamed:dataDic.taskLogo];
    // 定时器的命名规则为：定时器名字_时间戳
    NSArray *strArr = [dataDic.taskName componentsSeparatedByString:@"_"];
    self.textLb.text = strArr.firstObject;
//    if (dataDic.isDeafult) {
//        self.textLb.text = dataDic.taskName;
//    }else{
//
//        NSArray *strArr = [dataDic.taskName componentsSeparatedByString:@"_"];
//        self.textLb.text = strArr.firstObject;
//    }
}

- (void)setIsEdit:(BOOL)isEdit
{
    _isEdit = isEdit;
    self.tranferImgView.hidden = isEdit;
//    self.selectImgView.hidden = !isEdit;
}

@end

