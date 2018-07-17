//
//  LightsDataPointModel.h
//  JieBao
//
//  Created by wen on 2018/7/17.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LightsDataPointModel : NSObject

/**设备id 机智云 */
@property (nonatomic, strong) NSString *dId;

@property (nonatomic, strong) NSNumber *switchNum;
@property (nonatomic, strong) NSNumber *modelNum;
@property (nonatomic, strong) NSNumber *color_blue1Num;
@property (nonatomic, strong) NSNumber *color_whiteNum;
@property (nonatomic, strong) NSNumber *color_blue2Num;
@property (nonatomic, strong) NSNumber *color_greenNum;
@property (nonatomic, strong) NSNumber *color_redNum;
@property (nonatomic, strong) NSNumber *volor_violetNum;
@property (nonatomic, strong) NSNumber *M1Num;
@property (nonatomic, strong) NSNumber *M2Num;
@property (nonatomic, strong) NSNumber *M3Num;
@property (nonatomic, strong) NSNumber *M4Num;
@property (nonatomic, strong) NSNumber *M5Num;
@property (nonatomic, strong) NSNumber *OverTempNum;
@property (nonatomic, strong) NSNumber *OverCurrentNum;
@property (nonatomic, strong) NSNumber *Fault_FanNum;
@property (nonatomic, strong) NSNumber *Fault_UARTNum;
@property (nonatomic, strong) NSNumber *TimerNum;

-(instancetype)initWithData:(NSDictionary *)dic withDid:(NSString *)did;


@end
