//
//  CircularSliderView.h
//  test
//
//  Created by peng on 16/3/16.
//  Copyright © 2016年 yunwan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CircularSliderView;
typedef enum : UInt8 {
    PaletteTypeBrightness,
    PaletteTypeTemp
}PaletteType;

@protocol CircularSliderViewDelegate <NSObject>

-(void)paletteView:(CircularSliderView *)paletteView changeStatusWithCurrectStatus:(BOOL)status;
-(void)paletteView:(CircularSliderView *)paletteView getColorTemperature:(CGFloat)temp withGestureRecognizerState:(UIGestureRecognizerState)state;
-(void)paletteView:(CircularSliderView *)paletteView getBrightness:(CGFloat)brightness withGestureRecognizerState:(UIGestureRecognizerState)state isDown:(BOOL)isDown;


-(void)switchImageChanged:(BOOL)switchStatus;

@end





@interface CircularSliderView : UIView


@property (assign, nonatomic) id<CircularSliderViewDelegate> delegate;
@property (assign, nonatomic) BOOL  status;

@property (strong, nonatomic) UIColor   *brightnessColor;

@property(assign,nonatomic)BOOL isCold;
-(void)setPaletteType:(PaletteType)paletteType;



//wen
@property(assign,nonatomic)BOOL switchStatus;

//-(void)setTempValue:(CGFloat)value;
//-(void)setBrighenessValue:(CGFloat)value;

-(void)setUpPickeViewValue:(CGFloat)value;
-(void)setDownPickeViewValue:(CGFloat)value;




@end
