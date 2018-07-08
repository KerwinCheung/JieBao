//
//  LoadingHelper.m
//  JieBao
//
//  Created by yangzhenmin on 2018/4/19.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "LoadingHelper.h"
#import <SDWebImage/UIImage+GIF.h>

@interface LoadingHelper()

@property (nonatomic, strong) UIImageView *loadingImgView;

@end

@implementation LoadingHelper

- (void)showLoadingInView:(UIView *)view
{
    [view addSubview:self.loadingImgView];
    [self.loadingImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(view);
        make.size.mas_equalTo(CGSizeMake(CurrentDeviceSize(60), CurrentDeviceSize(60)));
    }];
}

- (void)dismissLoading
{
    [self.loadingImgView removeFromSuperview];
}

- (UIImageView *)loadingImgView
{
    if (!_loadingImgView) {
        _loadingImgView = [UIImageView new];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"loading" ofType:@"gif"];
        UIImage *img = [UIImage sd_animatedGIFWithData:[NSData dataWithContentsOfFile:path]];
        _loadingImgView.image = img;
    }
    return _loadingImgView;
}
@end
