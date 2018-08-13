//
//  DeviceCollectionViewCell.m
//  JieBao
//
//  Created by yangzhenmin on 2018/6/6.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "OpenGroupCollectionViewCell.h"

@interface OpenGroupCollectionViewCell()

@property (nonatomic, strong) UIImageView *img;

@property (nonatomic, strong) UILabel *lb;

@property (nonatomic, assign) BOOL clicked;

@end

@implementation OpenGroupCollectionViewCell

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
        if ([self.delegate respondsToSelector:@selector(OpenGroupCollectionViewCell:longTapWithIndexPath:)]) {
            [self.delegate OpenGroupCollectionViewCell:self longTapWithIndexPath:self.indexPath];
        }
    }
    
}

#pragma mark - method

-(void)setCellStatus:(BOOL)isStatus{
    //设置开启或关闭状态
    self.clicked = isStatus;
    if (self.clicked) {
        self.img.image = [SelectImageHelper selectDeviceSelectedImageWithTpye:self.customDev.product_key];
    }else
    {
        self.img.image = [SelectImageHelper selectDeviceImageWithTpye:self.customDev.product_key];
    }
}

-(void)setCellNoConnected{
    // 设置未连接状态
        self.img.image = [SelectImageHelper selectDeviceNoConnectedWithTpye:self.customDev.product_key];
}

- (BOOL)isSwitchOn
{
    return self.clicked;
}

-(void)setCustomDev:(CustomDevice *)customDev{
    _customDev = customDev;
    self.img.image = [SelectImageHelper selectDeviceImageWithTpye:customDev
                      .product_key];
    

    
   
    
    if (customDev.dev_alias.length > 0) {
        self.lb.text = customDev.dev_alias;

    }else{
        //显示默认名称
        GizWifiDevice *currentDev = nil;
        for (GizWifiDevice *dev in SDKHELPER.deviceArray) {
            if ([dev.did isEqualToString:customDev.did]) {
                currentDev = dev;
                break;
            }
        }
        NSRange range = NSMakeRange(currentDev.macAddress.length - 6, 6);
        NSString *lastMacStr = [currentDev.macAddress substringWithRange:range];
        NSString *deaultStr = [NSString stringWithFormat:@"%@%@",[UtilHelper getDefaultNameStrPrefixWithProductKey:currentDev.productKey],lastMacStr];
        self.lb.text = deaultStr;
    }
}

#pragma mark - lazy init
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

@end
