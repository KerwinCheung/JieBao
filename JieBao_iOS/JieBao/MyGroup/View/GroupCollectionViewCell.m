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
        if ([self.delegate respondsToSelector:@selector(GroupCollectionViewCellCell:longTapWithIndexPath:)]) {
            [self.delegate GroupCollectionViewCellCell:self longTapWithIndexPath:self.indexPath];
        }
    }
    
}

#pragma mark - method
- (void)cellSetSelected
{
    self.clicked = !self.clicked;
    if (self.clicked) {
        self.img.image = [SelectImageHelper selectGroupSelectedImageWithTpye:self.group.product_key];
    }else
    {
        self.img.image = [SelectImageHelper selectGroupImageWithTpye:self.group.product_key];
    }
}

-(void)setCellStatus:(BOOL)isStatus{
    self.clicked = isStatus;
    if (self.clicked) {
        self.img.image = [SelectImageHelper selectGroupSelectedImageWithTpye:self.group.product_key];
    }else
    {
        self.img.image = [SelectImageHelper selectGroupImageWithTpye:self.group.product_key];
    }
}


- (BOOL)isSwitchOn
{
    return self.clicked;
}

-(void)setGroup:(CustomDeviceGroup *)group{
    _group = group;
    self.img.image = [SelectImageHelper selectGroupImageWithTpye:group.product_key];
    self.lb.text = group.group_name;
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
