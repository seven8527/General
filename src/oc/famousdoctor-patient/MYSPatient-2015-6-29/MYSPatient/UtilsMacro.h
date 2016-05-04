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

// 判断手机系列
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

// URL根路径
//#define kURL_ROOT @"http://192.168.1.169/mobile_api/mobile"

//#define kURL_ROOT @"http://mobileapi.nethealth.cn/mobile/" // 测试地址
//#define kURL_PAY @"http://mobileapi.nethealth.cn/"  // 支付测试地址
//#define kURL @"http://yiiapi.nethealth.cn/" // 新测试地址


// 中间件
//#define kURL_ROOT @"http://nethealth.eicp.net:11000/dispatch/" // 测试地址
//#define kURL_PAY @"http://192.168.0.20:11000/"  // 支付测试地址
//#define kURL @"http://nethealth.eicp.net:11000/" // 新测试地址


#define kURL_ROOT @"http://mobileapi.mingyisheng.com/mobile/" // 上线地址
#define kURL_PAY @"http://mobileapi.mingyisheng.com/" // 支付上线地址
#define kURL @"http://yiiapi.mingyisheng.com/" // 上线地址

//#define KURL_HEALTHPLATFORM @"http://124.115.16.83:6000" // 西安健康档案测试地址

#define kNumberOfPage @"20" // 默认加载20条

// 设置颜色值
#define KEDEDEDColor @"EDEDED" //背景颜色
#define KC2C2C2Color @"c2c2c2"
#define K69AE42Color @"69ae42"
#define K9D76AAColor @"9d76aa"
#define K398CCCColor @"398ccc"
#define KEF8004Color @"ef8004"
#define K333333Color @"333333"
#define K9E9E9EColor @"9e9e9e"
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
#define K989898Color @"989898"
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
#define KC6C6C6Color @"c6c6c6"
#define K8F8F8FColor @"8f8f8f"
#define KC2C1C0Color @"c2c1c0"


// QQ第三方登陆AppID
#define QQ_APP_ID @"1104472458"

// 微博第三方登陆AppID
#define WB_APP_ID @"144164028"
// 微博第三方登陆回调地址
#define WB_REDIRECT_URI @"http://www.mingyisheng.com"

// 微信第三方登陆AppID
#define WX_APP_ID @"wx84b2b09b83324c2b"
#define WX_SECRET @"a485d15722431f399981fd311f1456b1"


// 第三方登陆 - QQ类型
#define TYPE_QQ @"0"
// 第三方登陆 - 微博类型
#define TYPE_WB @"1"
// 第三方登陆 - 微信类型
#define TYPE_WX @"2"

// 第三方登陆 - QQ的Host
#define QQ_HOST @"qzapp"

// 第三方登陆 - 微信的scheme
#define WB_SCHEME @"wb144164028"


#define UMENG_APPKEY @"550bc50ffd98c54cba000203"


#define ApplicationDelegate                 ((AppDelegate *)[[UIApplication sharedApplication] delegate])

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
