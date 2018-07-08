#import "GroupCollectionViewCell.h"

@interface GroupCollectionViewCell()

@property (nonatomic, strong) UIImageView *img;

@property (nonatomic, strong) UILabel *lb;

@property (nonatomic, assign) BOOL clicked;

@end

@implementation GroupCollectionViewCell

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
            make.size.mas_equalTo(CGSizeMake(4*perWidth, 2*perWidth));
        }];
        
        [self.lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(weakself.img.mas_centerX);
            make.top.equalTo(weakself.img.mas_bottom).offset(CurrentDeviceSize(5));
            make.width.lessThanOrEqualTo(@100);
        }];
    }
    return self;
}

- (void)cellSetSelected
{
    self.clicked = !self.clicked;
    if (self.clicked) {
        self.img.image = [SelectImageHelper selectGroupSelectedImageWithTpye:self.dataDic.product_key];
    }else
    {
        self.img.image = [SelectImageHelper selectGroupImageWithTpye:self.dataDic.product_key];
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

- (void)setDataDic:(CustomDeviceGroup *)dataDic
{
    _dataDic = dataDic;
    self.img.image = [SelectImageHelper selectGroupImageWithTpye:dataDic.product_key];
    self.lb.text = dataDic.group_name;
}

@end
