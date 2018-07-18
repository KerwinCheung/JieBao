//
//  LightsDataPointModel.m
//  JieBao
//
//  Created by wen on 2018/7/17.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import "LightsDataPointModel.h"

@implementation LightsDataPointModel

-(instancetype)initWithData:(NSDictionary *)dic withDevice:(GizWifiDevice *)device{
    self = [super init];
    if (self) {
        /*{
         alerts =     {
         OverCurrent = 0;
         OverTemp = 0;
         };
         data =     {
         M1 = 26;
         M2 = 30;
         M3 = 28;
         M4 = 19;
         M5 = 21;
         Timer = 1;
         "color_blue1" = 60;
         "color_blue2" = 40;
         "color_green" = 20;
         "color_red" = 13;
         "color_white" = 75;
         mode = 6;
         switch = 0;
         "volor_violet" = 30;
         };
         faults =     {
         "Fault_Fan" = 0;
         "Fault_UART" = 0;
         };
         }*/
        NSDictionary *data = dic[@"data"];
        NSDictionary *alert = dic[@"alerts"];
        NSDictionary *faults = dic[@"faults"];
        self.switchNum = data[@"switch"];
        self.modelNum = data[@"mode"];
        self.TimerNum = data[@"Timer"];
        self.M1Num = data[@"M1"];
        self.M2Num = data[@"M2"];
        self.M3Num = data[@"M3"];
        self.M4Num = data[@"M4"];
        self.M5Num = data[@"M5"];
        self.color_blue1Num = data[@"color_blue1"];
        self.color_blue2Num = data[@"color_blue2"];
        self.color_greenNum = data[@"color_green"];
        self.color_redNum = data[@"color_red"];
        self.color_whiteNum = data[@"color_white"];
        self.volor_violetNum = data[@"volor_violet"];
        
        self.OverTempNum = alert[@"OverTemp"];
        self.OverCurrentNum = alert[@"OverCurrent"];
        self.Fault_FanNum = faults[@"Fault_Fan"];
        self.Fault_UARTNum = faults[@"Fault_UART"];
        
        self.device = device;
    }
    return self;
}

@end
