//
//  OpenGroupCell.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/13.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "OpenGroupCell.h"

#define perWidth  LL_ScreenWidth/10

@interface OpenGroupCell()

@property (nonatomic, strong) UIButton *groupImgBtn1;

@property (nonatomic, strong) UILabel *groupLb1;

@property (nonatomic, strong) UIButton *groupImgBtn2;

@property (nonatomic, strong) UILabel *groupLb2;

@property (nonatomic, strong) UIButton *groupImgBtn3;

@property (nonatomic, strong) UILabel *groupLb3;
@end

@implementation OpenGroupCell

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
    [self.contentView addSubview:self.groupImgBtn1];
    [self.contentView addSubview:self.groupLb1];
    [self.contentView addSubview:self.groupImgBtn2];
    [self.contentView addSubview:self.groupLb2];
    [self.contentView addSubview:self.groupImgBtn3];
    [self.contentView addSubview:self.groupLb3];
    
    [self makeContraints];
}

- (void)makeContraints
{
    LHWeakSelf(self);
    [self.groupImgBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(perWidth));
        make.top.equalTo(@(perWidth));
        make.size.mas_equalTo(CGSizeMake(2*perWidth, 2*perWidth));
    }];
    
    [self.groupLb1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.groupImgBtn1.mas_centerX);
        make.top.equalTo(weakself.groupImgBtn1.mas_bottom).offset(CurrentDeviceSize(5));
        make.width.lessThanOrEqualTo(@50);
        make.bottom.equalTo(@0);
    }];
    
    [self.groupImgBtn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.groupImgBtn1.mas_right).offset(perWidth);
        make.top.equalTo(weakself.groupImgBtn1.mas_top);
        make.width.equalTo(weakself.groupImgBtn1.mas_width);
        make.height.equalTo(weakself.groupImgBtn1.mas_height);
    }];
    
    [self.groupLb2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.groupImgBtn2.mas_centerX);
        make.top.equalTo(weakself.groupImgBtn2.mas_bottom).offset(CurrentDeviceSize(5));
        make.width.lessThanOrEqualTo(@50);
    }];
    
    [self.groupImgBtn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakself.groupImgBtn2.mas_right).offset(perWidth);
        make.top.equalTo(weakself.groupImgBtn1.mas_top);
        make.width.equalTo(weakself.groupImgBtn1.mas_width);
        make.height.equalTo(weakself.groupImgBtn1.mas_height);
    }];
    
    [self.groupLb3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakself.groupImgBtn3.mas_centerX);
        make.top.equalTo(weakself.groupImgBtn3.mas_bottom).offset(CurrentDeviceSize(5));
        make.width.lessThanOrEqualTo(@50);
    }];
}

- (void)groupBtnClicked:(UIButton *)btn
{
    
}

- (UIButton *)groupImgBtn1
{
    if (!_groupImgBtn1) {
        _groupImgBtn1 = [UIButton new];
        _groupImgBtn1.layer.masksToBounds = YES;
        _groupImgBtn1.layer.cornerRadius = perWidth;
        [_groupImgBtn1 addTarget:self action:@selector(groupBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _groupImgBtn1;
}

- (UILabel *)groupLb1
{
    if (!_groupLb1) {
        _groupLb1 = [UILabel new];
        _groupLb1.font = [UIFont sf_systemFontOfSize:13];
        _groupLb1.text = @"dfafa";
    }
    return _groupLb1;
}

- (UIButton *)groupImgBtn2
{
    if (!_groupImgBtn2) {
        _groupImgBtn2 = [UIButton new];
        _groupImgBtn2.layer.masksToBounds = YES;
        _groupImgBtn2.layer.cornerRadius = perWidth;
        [_groupImgBtn2 addTarget:self action:@selector(groupBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _groupImgBtn2;
}

- (UILabel *)groupLb2
{
    if (!_groupLb2) {
        _groupLb2 = [UILabel new];
        _groupLb2.font = [UIFont sf_systemFontOfSize:13];
    }
    return _groupLb2;
}

- (UIButton *)groupImgBtn3
{
    if (!_groupImgBtn3) {
        _groupImgBtn3 = [UIButton new];
        _groupImgBtn3.layer.masksToBounds = YES;
        _groupImgBtn3.layer.cornerRadius = perWidth;
        [_groupImgBtn3 addTarget:self action:@selector(groupBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _groupImgBtn3;
}

- (UILabel *)groupLb3
{
    if (!_groupLb3) {
        _groupLb3 = [UILabel new];
        _groupLb3.font = [UIFont sf_systemFontOfSize:13];
    }
    return _groupLb3;
}

- (void)setDataSource:(NSArray<CustomDevice *> *)dataSource
{
    _dataSource = dataSource;
    if (dataSource.count == 1) {
        self.groupImgBtn2.hidden = self.groupLb2.hidden = self.groupImgBtn3.hidden = self.groupLb3.hidden= YES;
    }else if (dataSource.count == 2)
    {
        self.groupImgBtn2.hidden = self.groupLb2.hidden = NO;
        self.groupImgBtn3.hidden = self.groupLb3.hidden= YES;
    }else if(dataSource.count == 3)
    {
        self.groupImgBtn2.hidden = self.groupLb2.hidden = self.groupImgBtn3.hidden = self.groupLb3.hidden= NO;
    }
    
    if (dataSource.count > 0) {
        [self.groupImgBtn1 setImage:[SelectImageHelper selectDeviceImageWithTpye:dataSource[0].product_key] forState:UIControlStateNormal];
        self.groupLb1.text = dataSource[0].dev_alias;
    }
   
    if (dataSource.count > 1) {
        [self.groupImgBtn2 setImage:[SelectImageHelper selectDeviceImageWithTpye:dataSource[1].product_key] forState:UIControlStateNormal];
        self.groupLb2.text = dataSource[1].dev_alias;
    }
    
    if (dataSource.count > 2) {
        [self.groupImgBtn3 setImage:[SelectImageHelper selectDeviceImageWithTpye:dataSource[2].product_key]forState:UIControlStateNormal];
        self.groupLb3.text = dataSource[2].dev_alias;
    }
}
@end
