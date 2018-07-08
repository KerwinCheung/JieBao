//
//  ChannelView.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/27.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "ChannelView.h"

@interface ChannelView()

@property (nonatomic, assign) ChannelType type;

@property (nonatomic, copy) NSString *channelName;

@property (nonatomic, strong) UIImageView *channelImgView;

@property (nonatomic, strong) UILabel *channelLb;

@property (nonatomic, strong) UIImageView *statusImgView;

@property (nonatomic, assign) ChannelStatusType statusType;

@end

@implementation ChannelView

- (instancetype)initWithFrame:(CGRect)frame channelName:(NSString *)channelName Type:(ChannelType)type
{
    if (self = [super initWithFrame:frame]) {
        self.channelName = channelName;
        self.type = type;
        [self initUI];
    }
    return self;
}

- (void)initUI
{
    [self addSubview:self.channelImgView];
    [self.channelImgView addSubview:self.channelLb];
    [self addSubview:self.statusImgView];
    
    LHWeakSelf(self)
    if (self.type == ChannelRight) {
        [self.channelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(@0);
            make.width.equalTo(@(weakself.bounds.size.width/5*3));
        }];
        
        [self.statusImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakself.channelImgView);
            make.size.mas_equalTo(CGSizeMake(weakself.bounds.size.width/5, weakself.bounds.size.width/5));
            make.right.equalTo(@0);
        }];
    }else
    {
        [self.statusImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakself.mas_centerY);
            make.size.mas_equalTo(CGSizeMake(weakself.bounds.size.width/5, weakself.bounds.size.width/5));
            make.left.equalTo(@0);
        }];
        
        [self.channelImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.equalTo(@0);
            make.width.equalTo(@(weakself.bounds.size.width/5*3));
        }];
    }
   
    [self.channelLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(weakself.channelImgView);
        make.width.lessThanOrEqualTo(@200);
    }];
}

- (void)setStatus:(ChannelStatusType)status
{
    self.statusType = status;
    switch (status) {
        case ChannelStatusTiming:
            self.statusImgView.image = [UIImage imageNamed:@"yushechengxu"];
            break;
        case ChannelStatusShoudong:
            self.statusImgView.image = [UIImage imageNamed:@"shoudong2"];
            break;
        case ChannelStatusOff:
            self.statusImgView.image = [UIImage imageNamed:@"off"];
            break;
            
        default:
            break;
    }
}

- (void)longPress:(UILongPressGestureRecognizer *)ges
{
    if (ges.state != UIGestureRecognizerStateEnded) {
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(channelView:channelDoActionStatusType:)]) {
        [_delegate channelView:self channelDoActionStatusType:self.statusType];
    }
}

- (UIImageView *)channelImgView
{
    if (!_channelImgView) {
        _channelImgView = [UIImageView new];
        _channelImgView.image = [UIImage imageNamed:@"off_button"];
        _channelImgView.userInteractionEnabled = YES;
        UILongPressGestureRecognizer *ges = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [_channelImgView addGestureRecognizer:ges];
    }
    return _channelImgView;
}

- (UILabel *)channelLb
{
    if (!_channelLb) {
        _channelLb = [UILabel new];
        _channelLb.font = [UIFont sf_systemFontOfSize:13];
        _channelLb.textAlignment = NSTextAlignmentCenter;
        _channelLb.text = self.channelName;
    }
    return _channelLb;
}

- (UIImageView *)statusImgView
{
    if (!_statusImgView) {
        _statusImgView = [UIImageView new];
    }
    return _statusImgView;
}
@end
