//
//  PreinstallSelectView.m
//  JieBao
//
//  Created by yangzhenmin on 2018/6/3.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "PreinstallSelectView.h"

@interface PreinstallSelectView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pView;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIButton *confirmBtn;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, assign) NSInteger index;

@end

@implementation PreinstallSelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.layer.masksToBounds = YES;
        [self addSubview:self.pView];
        [self addSubview:self.lineView];
        [self addSubview:self.confirmBtn];
        
        
        LHWeakSelf(self)
        [self.pView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(@0);
            make.height.equalTo(@(CurrentDeviceSize(44)*2));
        }];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(@0);
            make.bottom.equalTo(weakself.pView.mas_top);
            make.height.equalTo(@(CurrentDeviceSize(0.5)));
        }];
        
        [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(@0);
            make.height.equalTo(@(CurrentDeviceSize(30)));
        }];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}
- (void)confirmBtnClicked:(UIButton *)btn
{
    if (_delegate && [_delegate respondsToSelector:@selector(selectIndex:)]) {
        [_delegate selectIndex:self.index];
    }
}



#pragma mark - PickerView Delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView

{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataSource.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%@",self.dataSource[row]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.index = row;
}


#pragma mark - lazy init
- (UIPickerView *)pView
{
    if (!_pView) {
        _pView = [UIPickerView new];
        _pView.backgroundColor = [UIColor whiteColor];
        _pView.delegate = self;
        _pView.dataSource = self;
    }
    return _pView;
}

- (UIView *)lineView
{
    if (!_lineView) {
        _lineView = [UIView new];
        _lineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _lineView;
}

- (UIButton *)confirmBtn
{
    if (!_confirmBtn) {
        _confirmBtn = [UIButton new];
        _confirmBtn.backgroundColor = [UIColor whiteColor];
        [_confirmBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_confirmBtn addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    }
    return _confirmBtn;
}

- (NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = @[@"SPS",@"LPS",@"Growth",@"Reef Aquarium"];
    }
    return _dataSource;
}

@end
