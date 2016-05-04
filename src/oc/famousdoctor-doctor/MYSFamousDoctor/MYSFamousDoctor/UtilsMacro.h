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
#define IOS8_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"8.0"] != NSOrderedAscending)
//#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)

// 设备屏幕尺寸
#define kScreen_Height   ([UIScreen mainScreen].bounds.size.height)
#define kScreen_Width    ([UIScreen mainScreen].bounds.size.width)
#define kScreen_Frame    (CGRectMake(0, 0, kScreen_Width, kScreen_Height))
#define kScreen_CenterX  kScreen_Width/2
#define kScreen_CenterY  kScreen_Height/2
#define kNavgBar_Height  self.navigationController.navigationBar.frame.size.height
#define kStatusBar_Height  [UIApplication sharedApplication].statusBarFrame.size.height
// 判断手机系列
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)


// URL根路径
//#define kURL_ROOT @"http://119.255.49.26/mobileapi/mobile/" // 测试地址
//#define kURL_ROOT @"http://mobileapi.mingyisheng.com/mobile/" // 上线地址
//#define kURL_ROOT @"http://124.254.5.170/nethealth.cn/mobile/"  // 正式数据
//#define kURL_ROOT @"http://192.168.1.169/mobile_api/mobile"

//#define kURL_ROOT @"http://119.255.49.29:82/expert/" // 测试地址

#define kURL_ROOT @"http://mobileapi.mingyisheng.com/expert/" // 上线地址

#define kPageSize 20 // 默认加载20条
#define kNumberOfPage @"20" // 默认加载20条

// 设置颜色值
#define KEDEDEDColor @"EDEDED" //背景颜色
#define KC2C2C2Color @"c2c2c2"
#define KC2C1C0Color @"c2c1c0"
#define K69AE42Color @"69ae42"
#define K9D76AAColor @"9d76aa"
#define K398CCCColor @"398ccc"
#define KEF8004Color @"ef8004"
#define K333333Color @"333333"
#define K363636Color @"363636"
#define K9E9E9EColor @"9e9e9e"
#define K919191Color @"919191"
#define KF6F6F6Color @"f6f6f6" // 导航背景颜色
#define k00947DColor @"00947d" // tabbar颜色
#define KEB3C00Color @"eb3c00" // 红色按钮颜色
#define KFFFFFFColor @"ffffff"
#define K525252Color @"525252"
#define K00A693Color @"00a693" // 默认绿色
#define K00907FColor @"00907f" // 按钮高亮默认颜色
#define K747474Color @"747474"
#define K525252Color @"525252"
#define K00907FColor @"00907f"
#define K69AF41Color @"69af41"
#define KD1D1D1Color @"d1d1d1"
#define K8F8F8FColor @"8f8f8f"
#define K989898Color @"989898"
#define K999999Color @"999999"
#define K00A48FColor @"00a48f"
#define KFAFAFAColor @"fafafa"
#define K484848Color @"484848"
#define KB8B8B8Color @"b8b8b8"
#define K000000Color @"000000"
#define K61A3D6Color @"61a3d6"
#define K68A8DBColor @"68a8d8"
#define KD9FAF6Color @"d9faf6"
#define KB3B3B3Color @"b3b3b3"
#define K575757Color @"575757"
#define KABABABColor @"ababab"
#define KB5B5B5Color @"b5b5b5"

// 网络咨询
#define FAMOUS_STATUS_NET @"0"
// 电话咨询
#define FAMOUS_STATUS_PHO @"1"
// 面对面咨询
#define FAMOUS_STATUS_FTF @"2"

#define USER_INFO_PLIST [NSString stringWithFormat:@"%@/Documents/userInfo.plist", NSHomeDirectory()]

#define MyWindow [[[UIApplication sharedApplication] windows] objectAtIndex:0]
#define ApplicationDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

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
