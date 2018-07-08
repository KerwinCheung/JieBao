//
//  SelectionView.m
//  JieBao
//
//  Created by yangzhenmin on 2018/5/16.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "SelectionView.h"

@interface SelectionView ()

@property (nonatomic, strong) UILabel *lb;

@property (nonatomic, strong) UILabel *sublb;

@property (nonatomic, strong) UIButton *btn;

@property (nonatomic, strong) UIView *sepline;

@end

@implementation SelectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.masksToBounds = YES;
        [self addSubview:self.lb];
        [self addSubview:self.sublb];
        [self addSubview:self.btn];
        [self addSubview:self.sepline];
        
        LHWeakSelf(self)
        [self.lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(CurrentDeviceSize(20)));
            make.centerY.equalTo(weakself.mas_centerY);
            make.width.lessThanOrEqualTo(@200);
        }];
        
        [self.sublb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakself.btn.mas_left).offset(-CurrentDeviceSize(5));
            make.centerY.equalTo(weakself.mas_centerY);
            make.width.lessThanOrEqualTo(@200);
        }];
        
        [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakself.mas_right).offset(-CurrentDeviceSize(20));
            make.centerY.equalTo(weakself.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(20), CurrentDeviceSize(20)));
        }];
        
        [self.sepline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(CurrentDeviceSize(20)));
            make.right.equalTo(weakself.mas_right);
            make.height.equalTo(@(CurrentDeviceSize(0.5)));
            make.bottom.equalTo(@0);
        }];
    }
    return self;
}

- (void)btnClicked
{
    if (_delegate && [_delegate respondsToSelector:@selector(transferBtnClicked:)]) {
        [_delegate transferBtnClicked:self];
    }
}

- (UILabel *)lb
{
    if (!_lb) {
        _lb = [UILabel new];
        _lb.font = [UIFont sf_systemFontOfSize:13];
    }
    return _lb;
}

- (UILabel *)sublb
{
    if (!_sublb) {
        _sublb = [UILabel new];
        _sublb.font = [UIFont sf_systemFontOfSize:13];
    }
    return _sublb;
}

- (UIButton *)btn
{
    if (!_btn) {
        _btn = [UIButton new];
        [_btn setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
        [_btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _btn;
}

- (UIView *)sepline
{
    if (!_sepline) {
        _sepline = [UIView new];
        _sepline.backgroundColor  = [UIColor lightGrayColor];
    }
    return _sepline;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.lb.text = title;
}

- (void)setSubtitle:(NSString *)subTitle
{
    _subTitle = subTitle;
    self.sublb.text = subTitle;
}

- (void)setSubTitle:(NSString *)subTitle
{
    _subTitle = subTitle;
    self.sublb.text = subTitle;
}

- (void)setTransferHidden:(BOOL)transferHidden
{
    _transferHidden = transferHidden;
    self.btn.hidden = transferHidden;
}

@end
