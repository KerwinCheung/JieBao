//
//  SpecificDefine.h
//  JieBao
//
//  Created by yangzhenmin on 2018/4/12.
//  Copyright © 2018年 yangzhenmin. All rights reserved.
//

#ifndef SpecificDefine_h
#define SpecificDefine_h


#define kSettingImgKey @"imgKey"

#define kSettingTextKey @"textKey"

#define kSettingRightImgKey @"rightImgKey"

#define kAPPThemeColor UICOLORFROMRGB(0x0079fb)

#define kAPPBackGround UICOLORFROMRGB(0xf8f8f8)

//自定义导航栏配置key
#define kCustomNaviBarLeftImgKey @"naviBarLeftImgKey"

#define kCustomNaviBarLeftTextKey @"naviBarLeftTextKey"

#define kCustomNaviBarLeftActionKey @"naviBarLeftActionKey"

#define kCustomNaviBarRightImgKey @"naviBarRightImgKey"

#define kCustomNaviBarRightActionKey  @"naviBarRightActionKey"

#define kCustomNaviBarTitleKey @"naviBarTitleKey"

#define kAppId @"5ebc091137ba4583bd47df82093c0578"

#define kAppSecrect @"9262af1fba194ed0a4c6f95d82071621"

#define kTimeSecs 60

#define kSynCurrentUserKey @"CurrentUserKey"

#define kSynMyDevicesKey @"MyDevicesKey"

#define kSynMyGroupsKey @"MyGroupsKey"

#define kUserLoginKey @"UserLoginKey"

#define kUserLogoutKey @"UserLogoutKey"

#define kUserWIFINameKey @"WifiNameKey"

#define kUserWIFIPSWKey @"WifiPswKey"

#define kUserWIFIKey @"WifiKey"

#define kChartHeight 220

#define perWidth  LL_ScreenWidth/10

#define ImageWidth CurrentDeviceSize(40)

#define ImageHeight CurrentDeviceSize(40)

#define ScrollFrame CGRectMake(0, CurrentDeviceSize(50) , LL_ScreenWidth , CurrentDeviceSize(280))

#define kErrorListsKey @"JeBaoError"

#define kProductKeys @{\
@"六路彩灯":@"efc08baa6b0a4de38d4bc9bce04ad350",@"滴定泵":@"5b3c136fd4b74f3fb2a366a254c76c9a",@"无线开关":@"db6a58856402414283ec174642629eea",\
@"造浪泵":@"f65982cb65da43baa0c722c84dd2740b",@"水泵":@"bd0febe99e724e3b8640ed955cd81972"\
}

#define kLPS @[\
@[@"0",@"0",@"0",@"0",@"0",@"5",@"10",@"15",@"20",@"25",@"30",@"40",@"51",@"62",@"62",@"51",@"40",@"30",@"25",@"20",@"15",@"10",@"0",@"0"],\
@[@"0",@"0",@"0",@"0",@"0",@"3",@"8",@"20",@"30",@"40",@"50",@"60",@"70",@"80",@"80",@"70",@"60",@"50",@"40",@"30",@"20",@"8",@"0",@"0"],\
@[@"0",@"0",@"0",@"0",@"0",@"5",@"15",@"30",@"45",@"56",@"68",@"75",@"85",@"90",@"90",@"85",@"75",@"68",@"56",@"45",@"30",@"15",@"0",@"0"],\
@[@"0",@"0",@"0",@"0",@"0",@"3",@"5",@"8",@"10",@"12",@"15",@"20",@"25",@"30",@"30",@"25",@"20",@"15",@"12",@"10",@"8",@"5",@"0",@"0"],\
@[@"0",@"0",@"0",@"0",@"0",@"0",@"3",@"3",@"6",@"8",@"10",@"13",@"17",@"20",@"20",@"17",@"13",@"10",@"8",@"6",@"3",@"3",@"0",@"0"],\
@[@"0",@"0",@"0",@"0",@"0",@"3",@"6",@"18",@"20",@"25",@"30",@"40",@"51",@"62",@"62",@"51",@"40",@"30",@"25",@"20",@"18",@"6",@"0",@"0"]\
]

#define kSPS @[\
@[@"0",@"0",@"0",@"0",@"0",@"5",@"15",@"30",@"45",@"56",@"68",@"75",@"85",@"90",@"90",@"85",@"75",@"68",@"56",@"45",@"30",@"15",@"0",@"0"],\
@[@"0",@"0",@"0",@"0",@"0",@"3",@"6",@"18",@"20",@"25",@"30",@"40",@"51",@"62",@"62",@"51",@"40",@"30",@"25",@"20",@"18",@"6",@"0",@"0"],\
@[@"0",@"0",@"0",@"0",@"0",@"3",@"8",@"20",@"30",@"40",@"50",@"60",@"70",@"80",@"80",@"70",@"60",@"50",@"40",@"30",@"20",@"8",@"0",@"0"],\
@[@"0",@"0",@"0",@"0",@"0",@"3",@"5",@"8",@"10",@"12",@"15",@"20",@"25",@"30",@"30",@"25",@"20",@"15",@"12",@"10",@"8",@"5",@"0",@"0"],\
@[@"0",@"0",@"0",@"0",@"0",@"0",@"3",@"3",@"6",@"8",@"10",@"13",@"17",@"20",@"20",@"17",@"13",@"10",@"8",@"6",@"3",@"3",@"0",@"0"],\
@[@"0",@"0",@"0",@"0",@"0",@"3",@"3",@"5",@"9",@"18",@"20",@"30",@"41",@"50",@"50",@"41",@"30",@"20",@"18",@"9",@"5",@"3",@"0",@"0"]\
]

#define kGrowth @[\
@[@"0",@"0",@"0",@"0",@"0",@"0",@"20",@"40",@"70",@"100",@"100",@"100",@"100",@"100",@"100",@"100",@"70",@"40",@"20",@"0",@"0",@"0",@"0",@"0"],\
@[@"0",@"0",@"0",@"0",@"0",@"10",@"30",@"50",@"80",@"100",@"100",@"100",@"100",@"100",@"100",@"100",@"80",@"50",@"30",@"10",@"3",@"0",@"0",@"0"],\
@[@"0",@"0",@"0",@"0",@"0",@"10",@"30",@"50",@"80",@"100",@"100",@"100",@"100",@"100",@"100",@"100",@"80",@"50",@"30",@"10",@"3",@"0",@"0",@"0"],\
@[@"0",@"0",@"0",@"0",@"0",@"0",@"10",@"30",@"60",@"100",@"100",@"100",@"100",@"100",@"100",@"100",@"60",@"30",@"10",@"0",@"0",@"0",@"0",@"0"],\
@[@"0",@"0",@"0",@"0",@"0",@"0",@"10",@"30",@"60",@"100",@"100",@"100",@"100",@"100",@"100",@"100",@"60",@"30",@"10",@"0",@"0",@"0",@"0",@"0"],\
@[@"0",@"0",@"0",@"0",@"0",@"10",@"30",@"50",@"80",@"100",@"100",@"100",@"100",@"100",@"100",@"100",@"80",@"50",@"30",@"10",@"3",@"0",@"0",@"0"]\
]

#define kReef @[\
@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"100",@"100",@"100",@"100",@"100",@"100",@"100",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"],\
@[@"0",@"0",@"0",@"0",@"0",@"50",@"50",@"50",@"50",@"100",@"100",@"100",@"100",@"100",@"100",@"100",@"50",@"50",@"50",@"50",@"50",@"0",@"0",@"0"],\
@[@"0",@"0",@"0",@"0",@"0",@"50",@"50",@"50",@"50",@"100",@"100",@"100",@"100",@"100",@"100",@"100",@"50",@"50",@"50",@"50",@"50",@"0",@"0",@"0"],\
@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"100",@"100",@"100",@"100",@"100",@"100",@"100",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"],\
@[@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"100",@"100",@"100",@"100",@"100",@"100",@"100",@"0",@"0",@"0",@"0",@"0",@"0",@"0",@"0"],\
@[@"0",@"0",@"0",@"0",@"0",@"50",@"50",@"50",@"50",@"100",@"100",@"100",@"100",@"100",@"100",@"100",@"50",@"50",@"50",@"50",@"50",@"0",@"0",@"0"]\
]
#endif /* SpecificDefine_h */
