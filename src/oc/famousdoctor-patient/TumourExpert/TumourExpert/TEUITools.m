//
//  TEUITools.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-9-23.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEUITools.h"
#import "UIColor+Hex.h"
#import "UIImage+Color.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>

@implementation TEUITools

/**
 *  自定义状态栏
 */
+ (void)customStatusBar
{
    if (IOS7_OR_LATER) { 
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    }
}

/**
 *  自定义导航栏
 */
+ (void)customNavigationBar
{

    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithHex:0x00947d]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeZero;
    // 统一设置标题字体大小、颜色，并去掉文字阴影
    [[UINavigationBar appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor whiteColor],
                                                            NSFontAttributeName: [UIFont boldSystemFontOfSize:20],
                                                            NSShadowAttributeName: shadow}];

}


/**
 *  隐藏表格多余的分割线
 *
 *  @param tableView 要隐藏的表格
 */
+ (void)hiddenTableExtraCellLine:(UITableView *)tableView
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


//是否允许下载图片

+ (BOOL)enableLoadPic
{
     NSString *switchStatus = [[NSUserDefaults standardUserDefaults] objectForKey:@"settingSwitch"];
     Reachability *reachability = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    if ([reachability currentReachabilityStatus] == ReachableViaWiFi) {
        return YES;
    } else if ([reachability currentReachabilityStatus] == ReachableViaWWAN  && [switchStatus isEqualToString:@"1"]) {
        return YES;
    } else {
        return NO;
    }
    return NO;
}
@end
