//
//  DeviceCollectionViewCell.m
//  JieBao
//
//  Created by yangzhenmin on 2018/6/6.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "DeviceCollectionViewCell.h"
@interface DeviceCollectionViewCell()

@property (nonatomic, strong) UIImageView *img;

@property (nonatomic, strong) UILabel *lb;

@property (nonatomic, assign) BOOL clicked;

@end

@implementation DeviceCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        [self.contentView addSubview:self.img];
        [self.contentView addSubview:self.lb];
        
        LHWeakSelf(self)
        [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@0);
            make.top.equalTo(@0);
            make.size.mas_equalTo(CGSizeMake(2*perWidth, 2*perWidth));
        }];
        
        [self.lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakself.img.mas_centerX);
            make.top.equalTo(weakself.img.mas_bottom).offset(CurrentDeviceSize(5));
            make.width.lessThanOrEqualTo(@100);
        }];
        
        [self addGest];
    }
    return self;
}

#pragma mark - 手势
-(void)addGest{
    UILongPressGestureRecognizer *ges = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
     [self addGestureRecognizer:ges];
}

-(void)longPress:(UIGestureRecognizer *)tap{
    // 长按
    if (tap.state == UIGestureRecognizerStateEnded) {
        if ([self.delegate respondsToSelector:@selector(DeviceCollectionViewCell:longTapWithIndexPath:)]) {
            [self.delegate DeviceCollectionViewCell:self longTapWithIndexPath:self.indexPath];
        }
    }
    
}





- (void)cellSetSelected
{
    self.clicked = !self.clicked;
    if (self.clicked) {
        self.img.image = [SelectImageHelper selectDeviceSelectedImageWithTpye:self.dataDic.productKey];
    }else
    {
        self.img.image = [SelectImageHelper selectDeviceImageWithTpye:self.dataDic.productKey];
    }
}

- (void)cellSetSelectedWithStatus:(BOOL)selected
{
    self.clicked = selected;
    if (self.clicked) {
        self.img.image = [SelectImageHelper selectDeviceSelectedImageWithTpye:self.dataDic.productKey];
    }else
    {
        self.img.image = [SelectImageHelper selectDeviceImageWithTpye:self.dataDic.productKey];
    }
    
    if (_dataDic.netStatus == GizDeviceOffline) {
        self.img.image = [SelectImageHelper selectDeviceNoConnectedWithTpye:self.dataDic.productKey];
    }
}

- (BOOL)isSwitchOn
{
    return self.clicked;
}

- (UILabel *)lb
{
    if (!_lb) {
        _lb = [UILabel new];
        _lb.font = [UIFont sf_systemFontOfSize:13];
        _lb.adjustsFontSizeToFitWidth = YES;
        _lb.textAlignment = NSTextAlignmentCenter;
    }
    return _lb;
}

- (UIImageView *)img
{
    if (!_img) {
        _img = [UIImageView new];
    }
    return _img;
}

- (void)setDataDic:(GizWifiDevice *)dataDic
{
    _dataDic = dataDic;
    if (self.clicked) {
        self.img.image = [SelectImageHelper selectDeviceSelectedImageWithTpye:self.dataDic.productKey];
    }else
    {
        self.img.image = [SelectImageHelper selectDeviceImageWithTpye:self.dataDic.productKey];
    }
    
    if (dataDic.netStatus == GizDeviceOffline) {
        self.img.image = [SelectImageHelper selectDeviceNoConnectedWithTpye:self.dataDic.productKey];
    }
    
    NSRange range = NSMakeRange(self.dataDic.macAddress.length - 6, 6);
    NSString *lastMacStr = [self.dataDic.macAddress substringWithRange:range];
    NSString *deaultStr = [NSString stringWithFormat:@"%@%@",[UtilHelper getDefaultNameStrPrefixWithProductKey:self.dataDic.productKey],lastMacStr];
    
    
    self.lb.text =  dataDic.alias.length >0 ? dataDic.alias:deaultStr;
}

-(void)setGroupWith:(CustomDeviceGroup *)group{
    self.img.image = [UIImage imageNamed:@"twoLamp"];
    self.lb.text = group.group_name;
}


@end
