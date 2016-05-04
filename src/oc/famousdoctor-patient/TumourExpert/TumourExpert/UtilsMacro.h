//
//  UtilsMacro.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-17.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#ifndef TumourExpert_UtilsMacro_h
#define TumourExpert_UtilsMacro_h

// 操作系统版本
#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)

// 设备屏幕尺寸
#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
#define kScreen_Frame    (CGRectMake(0, 0, kScreen_Width, kScreen_Height))
#define kScreen_CenterX  kScreen_Width/2
#define kScreen_CenterY  kScreen_Height/2

// URL根路径
//#define kURL_ROOT @"http://119.255.49.26/mobileapi/mobile/" // 测试地址
//#define kURL_ROOT @"http://mobileapi.mingyisheng.com/mobile/" // 上线地址
//#define kURL_ROOT @"http://124.254.5.170/nethealth.cn/mobile/"  // 正式数据
//#define kURL_ROOT @"http://192.168.1.169/mobile_api/mobile"

#define kURL_ROOT @"http://119.255.49.29:82/mobile/" // 测试地址
#define kURL @"http://119.255.49.29:82/"  // 测试地址

//#define kURL_ROOT @"http://mobileapi.mingyisheng.com/mobile/" // 上线地址
//#define kURL @"http://mobileapi.mingyisheng.com/" // 上线地址


#define ApplicationDelegate                 ((TEAppDelegate *)[[UIApplication sharedApplication] delegate])

#define kTEKeychainServiceName @"TEMingyisheng"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 调试模式
#ifdef DEBUG
#define LOG(...) NSLog(__VA_ARGS__);
#define LOG_METHOD NSLog(@"%s", __func__);
#else
#define LOG(...); 
#define LOG_METHOD;
#endif

#endif
