//
//  WeiShiCell.m
//  JieBao
//
//  Created by yangzhenmin on 2018/5/18.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "WeiShiCell.h"

@interface WeiShiCell()

@property (nonatomic, strong) UILabel *titleLb;

@property (nonatomic, strong) UIButton *transferBtn;

@end

@implementation WeiShiCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.titleLb];
        [self addSubview:self.transferBtn];
        
        LHWeakSelf(self)
        [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@(CurrentDeviceSize(20)));
            make.centerY.equalTo(weakself.mas_centerY);
            make.width.lessThanOrEqualTo(@200);
        }];
        
        [self.transferBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakself.mas_right).offset(-CurrentDeviceSize(20));
            make.centerY.equalTo(weakself.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(20), CurrentDeviceSize(20)));
        }];
    }
    return self;
}

- (void)transferBtnClicked
{
    if (_delegate && [_delegate respondsToSelector:@selector(transfer)]) {
        [_delegate transfer];
    }
}

- (UILabel *)titleLb
{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.font = [UIFont sf_systemFontOfSize:13];
    }
    return _titleLb;
}

- (UIButton *)transferBtn
{
    if (!_transferBtn) {
        _transferBtn = [UIButton new];
        [_transferBtn addTarget:self action:@selector(transferBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_transferBtn setImage:[UIImage imageNamed:@"next"] forState:UIControlStateNormal];
    }
    return _transferBtn;
}
@end
