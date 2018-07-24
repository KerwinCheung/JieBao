//
//  ShareListHeaderView.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/18.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "ShareListHeaderView.h"

@interface ShareListHeaderView()

@property (nonatomic, strong) UILabel *titleLb;

@end

@implementation ShareListHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.layer.masksToBounds = YES;
        [self addSubview:self.titleLb];
        self.backgroundColor = UICOLORFROMRGB(0xf0f0f0);
        [self makeContraints];
    }
    return self;
}

- (void)makeContraints
{
    [self.titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(CurrentDeviceSize(20)));
        make.top.equalTo(@(CurrentDeviceSize(5)));
        make.width.lessThanOrEqualTo(@(CurrentDeviceSize(200)));
    }];
}

- (UILabel *)titleLb
{
    if (!_titleLb) {
        _titleLb = [UILabel new];
        _titleLb.font = [UIFont sf_systemFontOfSize:13];
    }
    return _titleLb;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLb.text = title;
}
@end
