//
//  ZaoLangBengWeiShiCell.m
//  JieBao
//
//  Created by yangzhenmin on 2018/6/19.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "SuiBengWeiShiCell.h"

@interface SuiBengWeiShiCell()

@property (nonatomic, strong) UILabel *textLb;

@property (nonatomic, strong) UIButton *transferBtn;
@end

@implementation SuiBengWeiShiCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        LHWeakSelf(self);
        self.layer.masksToBounds = YES;
        [self.contentView addSubview:self.textLb];
        [self.contentView addSubview:self.transferBtn];
        [self.textLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakself.contentView);
            make.left.equalTo(@(CurrentDeviceSize(20)));
            make.width.lessThanOrEqualTo(@200);
        }];
        
        [self.transferBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakself.contentView);
            make.right.equalTo(weakself.contentView.mas_right).offset(-CurrentDeviceSize(20));
            make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(20), CurrentDeviceSize(20)));
        }];
    }
    return self;
}

- (void)transferBtnClicked
{
    
}

- (UILabel *)textLb
{
    if (!_textLb) {
        _textLb = [UILabel new];
        _textLb.font = [UIFont sf_systemFontOfSize:13];
    }
    return _textLb;
}

- (UIButton *)transferBtn
{
    if (!_transferBtn) {
        _transferBtn = [UIButton new];
        [_transferBtn setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
        [_transferBtn addTarget:self action:@selector(transferBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _transferBtn;
}

- (void)setText:(NSString *)text
{
    _text = text;
    self.textLb.text = text;
}
@end
