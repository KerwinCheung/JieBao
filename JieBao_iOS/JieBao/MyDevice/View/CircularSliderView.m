//
//  CircularSliderView.m
//  test
//
//  Created by peng on 16/3/16.
//  Copyright © 2016年 yunwan. All rights reserved.
//

#import "CircularSliderView.h"

#define  BGCOLOR UICOLORFROMRGB(0xef722e)

#define  ColdUpColor  UICOLORFROMRGB(0x34abff)
#define ColdDownColor  UICOLORFROMRGB(0xffffff)

#define HotUpColor  UICOLORFROMRGB(0xffbf25)
#define  HotDownColor  UICOLORFROMRGB(0x59d86b)

typedef enum : UInt8 {
    ControlIdenNone,
    ControlIdenSwitch,
    ControlIdenTemp,
    ControlIdenBrightness
}ControlIden;


@implementation CircularSliderView
{
    
    UIImageView *_brightnessImageView;
    UIImageView *_tempImageView;
    UIImageView *_statusImageView;
    
    UIImageView *_tempPickerImageView;
    UIImageView *_brightnessPickerImageView;
    UIImageView *_brightnessPickerImageView2;
    
    UILabel     *_statusLabel;
    
    CGFloat     _statusRadius, _tempRadius, _brightnessRadius;
    
    CGPoint     _centerPoint;
    
    ControlIden _controlIden;
    
    CGFloat _endAngle;
    
    CGFloat _downEndAngle;
    /**
     是否是下滑块
     */
    BOOL isdown;
    
    UIImageView *_switchImageView;
    
    /**
     气泡
     */
    UIImageView *_bubbleImageView;
    
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self=[super initWithCoder:aDecoder]) {
        [self initView];
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.frame = frame;
        [self initView];
        self.backgroundColor=[UIColor clearColor];
    }
    return self;
}
-(void)drawRect:(CGRect)rect{
    // Drawing code
    //    CGFloat startAngle = M_PI + M_PI_2;
    CGFloat startAngle = M_PI +M_PI/6;
    _downEndAngle=[self getAngleWithPoint:_brightnessPickerImageView2.center];
    _endAngle=[self getAngleWithPoint:_brightnessPickerImageView.center];
//    if (_downEndAngle>0 && _downEndAngle<M_PI_2){
//        _downEndAngle=M_PI*2;
//    }
//    else if (_downEndAngle>M_PI_2&&_downEndAngle<M_PI)
//    {
//        _downEndAngle=M_PI;
//    }
//    
//    if (_endAngle > M_PI  && _endAngle < M_PI+M_PI_4 ){
//        _endAngle=M_PI;
//    }
//    else if (_endAngle >M_PI+M_PI_2&&_endAngle<2*M_PI){
//        _endAngle=2*M_PI;
//    }
    
    
    UIColor *color;
    if (_isCold) {
        color=ColdUpColor;
    }
    else
    {
        color=HotUpColor;
    }
    
    [self drawArcWithRadius:_centerPoint.x withStartAngle:startAngle withEndAngle:_endAngle withColor:color];
    
    [self drawDownArcWithRadius:_centerPoint.x withStartAngle:startAngle withEndAngle:_downEndAngle withColor:ColdDownColor];
    
    
    [self drawArcWithRadius:_centerPoint.x withStartAngle:_endAngle withEndAngle:(2*M_PI-M_PI/6) withColor:UICOLORFROMRGB(0xdfdfdf)];
    
    [self drawDownArcWithRadius:_centerPoint.x withStartAngle:_downEndAngle withEndAngle:(2*M_PI-M_PI/6) withColor:UICOLORFROMRGB(0xc9c9c9)];
    
    
}
-(void)drawDownArcWithRadius:(CGFloat)radius withStartAngle:(CGFloat)startAngle withEndAngle:(CGFloat)endAngle withColor:(UIColor *)color{
    
    CGContextRef context =UIGraphicsGetCurrentContext();


    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextMoveToPoint(context, _centerPoint.x, _centerPoint.y);
    
    CGContextAddArc(context, _centerPoint.x, _centerPoint.y, radius, -startAngle, -endAngle, 1);
    
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
}

-(void)drawArcWithRadius:(CGFloat)radius withStartAngle:(CGFloat)startAngle withEndAngle:(CGFloat)endAngle withColor:(UIColor *)color{
    
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextMoveToPoint(context, _centerPoint.x, _centerPoint.y);
    
    CGContextAddArc(context, _centerPoint.x, _centerPoint.y, radius, -startAngle, -endAngle, 0);
    
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFillStroke);
}

-(void)initView{
        self.backgroundColor=UICOLORFROMRGB(0xc9c9c9);
    _endAngle = M_PI_2;
    _brightnessColor = [UIColor whiteColor];
    
    CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    _brightnessImageView = [[UIImageView alloc] initWithFrame:rect];
    [self addSubview:_brightnessImageView];
    
    _tempImageView = [[UIImageView alloc] initWithFrame:rect];
    [self addSubview:_tempImageView];
    
    _statusImageView = [[UIImageView alloc] initWithFrame:rect];
    [self addSubview:_statusImageView];
    
    
    //    _brightnessImageView.backgroundColor=[UIColor clearColor];
    //    _statusImageView.backgroundColor=BGCOLOR;
    //    _tempImageView.backgroundColor=[UIColor clearColor];
    
    _centerPoint = _brightnessImageView.center;
    
    _statusRadius = rect.size.width * 110.0 / 640.0;
    _tempRadius = rect.size.width * 182.5 / 640.0;
    _brightnessRadius = rect.size.width * 260 / 640.0;
    
    _brightnessPickerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0.15 * rect.size.width, 0.15 * rect.size.width)];
    [self addSubview:_brightnessPickerImageView];
    _brightnessPickerImageView.center = CGPointMake(_centerPoint.x, _centerPoint.y - _brightnessRadius);
    
    _brightnessPickerImageView2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0.15 * rect.size.width, 0.15 * rect.size.width)];
    [self addSubview:_brightnessPickerImageView2];
    _brightnessPickerImageView.center = CGPointMake(_centerPoint.x, _centerPoint.y - _brightnessRadius);
    
    _tempPickerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0.1 * rect.size.width, 0.1 * rect.size.width)];
    [self addSubview:_tempPickerImageView];
    _tempPickerImageView.center = CGPointMake(_centerPoint.x, _centerPoint.y - _tempRadius);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handTap:)];
    [self addGestureRecognizer:tap];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handPan:)];
    [self addGestureRecognizer:pan];
    
    //wen
    _bubbleImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 27*WidthRatio, 33*HeightRatio)];
    _bubbleImageView.image=[UIImage imageNamed:@"drop-拷贝-3@2x.png"];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, (_bubbleImageView.frame.size.height-15)/2-3, _bubbleImageView.frame.size.width,15)];
    
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor=[UIColor whiteColor];
    label.font=[UIFont systemFontOfSize:12];
    label.text=@"30";
    label.tag=1000;
    
    CGPoint point=_bubbleImageView.center;
    point.y= point.y-(0.15 * rect.size.width)/2-33/2;
    _bubbleImageView.center=point;
    
    [_bubbleImageView addSubview:label];
    
    _switchImageView =[[UIImageView alloc]initWithFrame:CGRectMake((self.frame.size.width-167)*0.5, (self.frame.size.height-167)*0.5, 167, 167)];
    _switchImageView.image=[UIImage imageNamed:@"关闭"];
    
    [self addSubview:_switchImageView];
    [self addSubview:_bubbleImageView];
    
}


//wen
-(void)setSwitchStatus:(BOOL)switchStatus
{
    _switchStatus=switchStatus;
    if (switchStatus) {
        _switchImageView.image=[UIImage imageNamed:@"开启"];
    }
    else
    {
        _switchImageView.image=[UIImage imageNamed:@"关闭"];
    }
}

-(void)setPaletteType:(PaletteType)paletteType{
    if (paletteType == PaletteTypeBrightness) {
        _tempImageView.hidden = YES;
        _tempPickerImageView.hidden = YES;
    }else if (paletteType == PaletteTypeTemp){
        _tempImageView.hidden = NO;
        _tempPickerImageView.hidden = _status;
    }
}

-(void)setStatus:(BOOL)status{
    _status = status;
    if (status) {
        //        _statusLabel.textColor =UICOLORFROMRGB(0xffc597);
        //        _statusLabel.text = @"开机";
        //        _statusImageView.image = [UIImage imageNamed:@"开启状态"];
        //        _tempImageView.image = [UIImage imageNamed:@"制冷调节"];
        //        _tempPickerImageView.image = [UIImage imageNamed:@"色温选择器"];
        _brightnessPickerImageView.image = [UIImage imageNamed:@"亮度调节器"];
        _brightnessPickerImageView2.image = [UIImage imageNamed:@"白光调节器"];
        
        _brightnessImageView.image = [UIImage imageNamed:@"透明@2x"];
    }else{
        //        _statusLabel.textColor = UICOLORFROMRGB(0xffc597);
        //        _statusLabel.text = @"关机";
        //        _statusImageView.image = [UIImage imageNamed:@"关闭状态"];
        //        _tempImageView.image = [UIImage imageNamed:@"色温圈-关闭状态"];
        //        _brightnessImageView.image = [UIImage imageNamed:@"色温圈-关闭状态"];
        //        _tempPickerImageView.image = nil;
        //        _brightnessPickerImageView.image = nil;
    }
}

//-(void)setTempValue:(CGFloat)value{
//    _controlIden = ControlIdenTemp;
//    CGFloat angle = [self valueToAngle:value];
//    [self setPickerPoint:[self getPointWithAngle:angle]];
//}

//-(void)setBrighenessValue:(CGFloat)value{
//    _controlIden = ControlIdenBrightness;
//    CGFloat angle = [self valueToAngle:value];
//    [self setPickerPoint:[self getPointWithAngle:angle]];
//    _endAngle = angle;
//    [self setNeedsDisplay];
//}

#pragma mark - 根据value设置上滑条的位置
-(void)setUpPickeViewValue:(CGFloat)value
{
    _controlIden=ControlIdenBrightness;
    CGFloat angle=[self upValueToAngle:value];
    CGPoint point=[self getPointWithAngle:angle];
    //配置气泡上的数值
    [self setLabelValueToBubble:angle];
    _brightnessPickerImageView.center=point;
    
    
    [self setNeedsDisplay];
    
    
    CGPoint point1=point;
    point1.y=point1.y -(_brightnessPickerImageView.height)/2-33/2;
    
    
    if (point.x>=_centerPoint.x) {
       
        
        CGFloat angle=[self getAngleWithPoint:point];
        CGFloat revolve=M_PI_2-angle;
        _bubbleImageView.transform=CGAffineTransformMakeRotation(revolve);
        CGPoint point2=[self getPointByAngle:angle withRadius:_brightnessRadius+_bubbleImageView.width/2+_brightnessPickerImageView.width/2];
        
        _bubbleImageView.center=point2;
        
        
        [self setLabelValueToBubble:angle];
    }
    else
    {
        
        CGFloat angle=[self getAngleWithPoint:point];
        CGFloat revolve=angle-M_PI_2;
        _bubbleImageView.transform=CGAffineTransformMakeRotation(-revolve);
        CGPoint point2=[self getPointByAngle:angle withRadius:_brightnessRadius+_bubbleImageView.width/2+_brightnessPickerImageView.width/2];
        _bubbleImageView.center=point2;
        
        [self setLabelValueToBubble:angle];
        
        
    }
    

    
    
}

#pragma mark - 根据value设置下滑条的位置
-(void)setDownPickeViewValue:(CGFloat)value
{   _controlIden=ControlIdenBrightness;
    CGFloat angle=[self downValueToAngle:value];
    CGPoint point=[self getPointWithAngle:angle];
    _brightnessPickerImageView2.center=point;
    [self setNeedsDisplay];
}


#pragma mark - 改变气泡上的数值

-(void)setLabelValueToBubble:(CGFloat)angle
{
    CGFloat value=[self angleToValue:angle];
    UILabel *label=(UILabel *)[_bubbleImageView viewWithTag:1000];
    label.text=[NSString stringWithFormat:@"%d",(int)(value*99)+1];
}
#pragma mark -根据角度和半径得到一个point
 
-(CGPoint)getPointByAngle:(CGFloat)angle withRadius:(CGFloat)radius{
    CGPoint point = CGPointMake(0, 0);
    
    point.x = _centerPoint.x + cos(angle) * radius;
    point.y = _centerPoint.y - sin(angle) * radius;
    
    return point;
}
#pragma mark- 点击事件
-(void)handTap:(UITapGestureRecognizer *)gest{
    
    CGPoint point = [gest locationInView:gest.view];
    CGFloat min=(self.frame.size.width-167)*0.5;
    CGFloat max=self.frame.size.width-min;
    if (point.x<max&&point.x>min&&point.y>min&&point.y<max){
        //点击范围是开关键时
//        self.switchStatus=!self.switchStatus;
        if ([_delegate respondsToSelector:@selector(switchImageChanged:)]) {
            [_delegate switchImageChanged:self.switchStatus];
        }
    }
    else{
    
        if (_controlIden == ControlIdenSwitch) {
            if ([_delegate respondsToSelector:@selector(paletteView:changeStatusWithCurrectStatus:)]) {
                [_delegate paletteView:self changeStatusWithCurrectStatus:_status];
            }
        }else if ((_controlIden == ControlIdenTemp || _controlIden == ControlIdenBrightness) && _status != 0) {
            CGPoint point = [gest locationInView:gest.view];
            CGFloat angle = [self getAngleWithPoint:point];
            //        angle = [self getValidAngleWithAngle:angle];
            //        [self setPickerPoint:[self getPointWithAngle:angle]];
            
            
            
            
            
            if (angle >= 3.864  && angle <= 5.605){
                isdown=YES;
            }
            else if (angle<=3.637 ||angle> 5.812)
            {
                isdown=NO;
            }
            
            if (isdown) {
                //下滑块
                if (angle >= 3.864  && angle <= 5.605) {
                    [self setPickerAngle:angle];
                    
                    if (_controlIden == ControlIdenTemp) {
                        if ([_delegate respondsToSelector:@selector(paletteView:getColorTemperature:withGestureRecognizerState:)]) {
                            [_delegate paletteView:self getColorTemperature:[self angleToValue:angle] withGestureRecognizerState:gest.state];
                        }
                    }else if (_controlIden == ControlIdenBrightness){
                        if ([_delegate respondsToSelector:@selector(paletteView:getBrightness:withGestureRecognizerState:isDown:)]) {
                            
                            [_delegate paletteView:self getBrightness:[self angleToValue:angle] withGestureRecognizerState:gest.state isDown:isdown];
                        }
                        //            _endAngle = angle;
                        [self setNeedsDisplay];
                    }
                }
            }
            else{
                //上滑块
                if (angle<=3.637 ||angle> 5.812){
                    [self setPickerAngle:angle];
                    
                    if (_controlIden == ControlIdenTemp) {
                        if ([_delegate respondsToSelector:@selector(paletteView:getColorTemperature:withGestureRecognizerState:)]) {
                            [_delegate paletteView:self getColorTemperature:[self angleToValue:angle] withGestureRecognizerState:gest.state];
                        }
                    }else if (_controlIden == ControlIdenBrightness){
                        if ([_delegate respondsToSelector:@selector(paletteView:getBrightness:withGestureRecognizerState:isDown:)]) {
                            
                            [_delegate paletteView:self getBrightness:[self angleToValue:angle] withGestureRecognizerState:gest.state isDown:isdown];
                        }
                        //            _endAngle = angle;
                        [self setNeedsDisplay];
                    }
                }
            }
            
            
        }
    }
}

//拖动事件
-(void)handPan:(UIPanGestureRecognizer *)gest{
    //关闭状态
    if (_status == 0) {
        return;
    }
    if (gest.state==UIGestureRecognizerStateBegan) {
        CGPoint point = [gest locationInView:gest.view];
        CGFloat angle = [self getAngleWithPoint:point];
        if (angle >= 3.864  && angle <= 5.605){
            isdown=YES;
        }
        else if (angle<=3.637 ||angle> 5.812)
        {
            isdown=NO;
        }
    }
    
    if (gest.state == UIGestureRecognizerStateChanged || gest.state == UIGestureRecognizerStateEnded){
        if (_controlIden == ControlIdenTemp || _controlIden == ControlIdenBrightness) {
            CGPoint point = [gest locationInView:gest.view];
            CGFloat angle = [self getAngleWithPoint:point];
            //            angle = [self getValidAngleWithAngle:angle];
            [self setPickerAngle:angle];
            //            [self setPickerPoint:[self getPointWithAngle:angle]];
            if (isdown) {
                //下滑块
                if (angle >= 3.864  && angle <= 5.605){
                    if (_controlIden == ControlIdenTemp) {
                        if ([_delegate respondsToSelector:@selector(paletteView:getColorTemperature:withGestureRecognizerState:)]) {
                            [_delegate paletteView:self getColorTemperature:[self angleToValue:angle] withGestureRecognizerState:gest.state];
                        }
                    }else if (_controlIden == ControlIdenBrightness){
                        if ([_delegate respondsToSelector:@selector(paletteView:getBrightness:withGestureRecognizerState:isDown:)]) {
                            
                            [_delegate paletteView:self getBrightness:[self angleToValue:angle] withGestureRecognizerState:gest.state isDown:isdown];
                        }
                        
                        [self setNeedsDisplay];
                    }
                }
              
            }
            else{
                //上滑块
                if (angle<=3.637 ||angle> 5.812){
                    if (_controlIden == ControlIdenTemp) {
                        if ([_delegate respondsToSelector:@selector(paletteView:getColorTemperature:withGestureRecognizerState:)]) {
                            [_delegate paletteView:self getColorTemperature:[self angleToValue:angle] withGestureRecognizerState:gest.state];
                        }
                    }else if (_controlIden == ControlIdenBrightness){
                        if ([_delegate respondsToSelector:@selector(paletteView:getBrightness:withGestureRecognizerState:isDown:)]) {
                            
                            [_delegate paletteView:self getBrightness:[self angleToValue:angle] withGestureRecognizerState:gest.state isDown:isdown];
                        }
                        
                        [self setNeedsDisplay];
                    }
                }
                
            }
            
        }
    }
}

-(CGFloat)getRadiusWithPoint:(CGPoint)point{
    return sqrt((point.x - _centerPoint.x) * (point.x - _centerPoint.x) + (point.y - _centerPoint.y) * (point.y - _centerPoint.y));
}

-(CGFloat)getAngleWithPoint:(CGPoint)point{
    point.x -= _centerPoint.x;
    point.y = _centerPoint.y - point.y;
    CGFloat angle = atan2(point.y , point.x);
    if (angle < 0) {
        angle = angle + M_PI * 2;
    }
    return angle;
}

-(CGFloat)getValidAngleWithAngle:(CGFloat)angle{
    if (angle > M_PI + M_PI_2 - M_PI / 6 && angle < M_PI + M_PI_2 + M_PI / 6){
        UIView *picker = _controlIden == ControlIdenTemp ? _tempPickerImageView : _brightnessPickerImageView;
        if (picker.center.x < _centerPoint.x) {
            angle = M_PI + M_PI_2 - M_PI / 6;
        }else{
            angle = M_PI + M_PI_2 + M_PI / 6;
        }
    }
    return angle;
}

-(CGPoint)getPointWithAngle:(CGFloat)angle{
    CGFloat radius = _controlIden == ControlIdenTemp ? _tempRadius : _brightnessRadius;
    if (radius<100) {
        NSLog(@"radius>>>>>>>>>%f  tempRadius %f  brightnessR %f",radius,_tempRadius,_brightnessRadius);
    }
    
    CGPoint point;
    point.x = cos(angle) * radius;
    point.y = sin(angle) * radius;
    point.x += _centerPoint.x;
    point.y = _centerPoint.y - point.y;
    return point;
}

-(CGFloat)angleToValue:(CGFloat)angle{
    
    if (angle >= 3.864  && angle <= 5.605){
        
        return (angle-3.864)/(5.605-3.864);
    }
    else
    {
        CGFloat myAngel = 0;
        
        if (angle > M_PI + M_PI_2) {
            myAngel = 3.637+2*M_PI-angle;
        }else{
            myAngel = 3.637-angle;
//            NSLog(@"--->%f   %f",M_PI+M_PI/3,angle);
        }
        
        return (CGFloat)fabs(myAngel / (3.637+2*M_PI-5.812)) ;
    }
    
}

-(CGFloat)upValueToAngle:(CGFloat)value{
    
    
    value *=(3.637+2*M_PI-5.812);
    
    value = 3.637  - value;
    if (value < 0) {
        value += M_PI * 2;
    }
    
    
    return value;
    
}

-(CGFloat)downValueToAngle:(CGFloat)value{
    
    
    value *=(5.605-3.864);
    
    return value+3.864;
    
}

-(void)setPickerPoint:(CGPoint)point{
    UIView *picker = nil;
    if (_controlIden == ControlIdenTemp) {
        picker = _tempPickerImageView;
    }else{
        picker = _brightnessPickerImageView;
        
    }
    picker.center = point;
}


#pragma mark-  根据角度来选择选择器并设置位置
 
-(void)setPickerAngle:(CGFloat)angle
{
    //    UIView *picker = nil;
    if (_controlIden == ControlIdenTemp) {
        //        picker = _tempPickerImageView;
    }else{
        CGPoint point=[self getPointWithAngle:angle];
//        NSLog(@"角度>>>>>>>>>>>>>>%f",angle);
        if (isdown) {
//            if (angle >= M_PI+M_PI/6  && angle <= 2*M_PI-M_PI/6 ){
//                _brightnessPickerImageView2.center=point;
//            }
            if (angle >= 3.864  && angle <= 5.605){
                _brightnessPickerImageView2.center=point;
            }
        }
        else
        {
//            (angle<=M_PI+M_PI/6 ||angle> 2*M_PI-M_PI/6)
            if (angle<=3.637 ||angle> 5.812){
                _brightnessPickerImageView.center=point;
                
                CGPoint point1=point;
                point1.y=point1.y -(_brightnessPickerImageView.height)/2-33/2;
                
                
                if (point.x>=_centerPoint.x) {
                    //            point1.x+=picker.width/2;
                    //            _bubbleImageView.center=point1;
                    
                    CGFloat angle=[self getAngleWithPoint:point];
                    CGFloat revolve=M_PI_2-angle;
                    _bubbleImageView.transform=CGAffineTransformMakeRotation(revolve);
                    CGPoint point2=[self getPointByAngle:angle withRadius:_brightnessRadius+_bubbleImageView.width/2+_brightnessPickerImageView.width/2];
                    
                    _bubbleImageView.center=point2;
                    
                    
                    [self setLabelValueToBubble:angle];
                }
                else
                {
                   
                    CGFloat angle=[self getAngleWithPoint:point];
                    CGFloat revolve=angle-M_PI_2;
                    _bubbleImageView.transform=CGAffineTransformMakeRotation(-revolve);
                    CGPoint point2=[self getPointByAngle:angle withRadius:_brightnessRadius+_bubbleImageView.width/2+_brightnessPickerImageView.width/2];
                    _bubbleImageView.center=point2;
                    
                    [self setLabelValueToBubble:angle];
                    
                    
                }

                
                
            }
        }
     
    }
}
-(void)setControlIdenWithRadius:(CGFloat)radius withAngle:(CGFloat)angle{
  
    
    
    if (radius <= _statusRadius) {
        _controlIden = ControlIdenSwitch;
    }else if (radius >= _tempRadius - self.frame.size.width * 45.0 / 640.0 && radius <= _tempRadius + self.frame.size.width * 35.0 / 640.0  ){
        _controlIden = ControlIdenTemp;
    }else if (radius >= _brightnessRadius - self.frame.size.width * 35.0 / 640.0 && radius <= _brightnessRadius + self.frame.size.width * 35.0 / 640.0 ){
        _controlIden = ControlIdenBrightness;
    }else{
        _controlIden = ControlIdenNone;
    }
}

-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    CGFloat radius = [self getRadiusWithPoint:point];
    CGFloat angle = [self getAngleWithPoint:point];
    [self setControlIdenWithRadius:radius withAngle:angle];
    if (_controlIden != ControlIdenNone) {
        return self;
    }
    return nil;
}







@end
