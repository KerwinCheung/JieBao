//
//  EditGroupCell.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/14.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "CaiDengTimingAddCell.h"

@interface CaiDengTimingAddCell()

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UILabel *textLb;

@property (nonatomic, strong) UIButton *tranferBtn;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation CaiDengTimingAddCell

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
    [self.contentView addSubview:self.textLb];
    [self.contentView addSubview:self.tranferBtn];
    [self.contentView addSubview:self.lineView];
    
    [self makeContraints];
}

- (void)makeContraints
{
    LHWeakSelf(self)
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakself).insets(UIEdgeInsetsZero);
    }];
    
    [self.textLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakself.mas_centerY);
        make.left.equalTo(@(CurrentDeviceSize(30)));
        make.width.lessThanOrEqualTo(@100);
    }];
    
    [self.tranferBtn mas_makeConstraints:^(MASConstraintMaker *make) {
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

- (void)tranferBtnClicked
{
    if (_delegate && [_delegate respondsToSelector:@selector(addSchBtnClicked)]) {
        [_delegate addSchBtnClicked];
    }
}

- (UILabel *)textLb
{
    if (!_textLb) {
        _textLb = [UILabel new];
        _textLb.font = [UIFont sf_systemFontOfSize:13];;
        _textLb.text = @"添加定时程序";
    }
    return _textLb;
}

- (UIButton *)tranferBtn
{
    if (!_tranferBtn) {
        _tranferBtn = [UIButton new];
        [_tranferBtn setImage:[UIImage imageNamed:@"tianjia2"] forState:UIControlStateNormal];
        [_tranferBtn addTarget:self action:@selector(tranferBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tranferBtn;
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

@end


