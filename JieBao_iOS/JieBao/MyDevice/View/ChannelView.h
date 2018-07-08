//
//  ChannelView.h
//  JieBao
//
//  Created by yangzhenmin on 2018/4/27.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,ChannelType){//状态按钮的位置 
    ChannelLeft = 1,
    ChannelRight
};

typedef NS_ENUM(NSInteger,ChannelStatusType){
    ChannelStatusTiming = 1,
    ChannelStatusShoudong,
    ChannelStatusOff
};


@protocol ChannelViewDelegate<NSObject>

- (void)channelView:(id)view channelDoActionStatusType:(ChannelStatusType)type ;

@end


@interface ChannelView : UIView

@property (nonatomic, weak) id<ChannelViewDelegate>delegate;

@property (nonatomic, copy) NSString *channe;

- (instancetype)initWithFrame:(CGRect)frame channelName:(NSString *)channelName Type:(ChannelType)type;

- (void)setStatus:(ChannelStatusType)status;



@end
