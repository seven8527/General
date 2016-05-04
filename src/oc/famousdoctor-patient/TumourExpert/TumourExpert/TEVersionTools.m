//
//  TEVersionTools.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-8-1.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEVersionTools.h"
#import "UIDevice+SupportedDevices.h"

/// i18n/l10n macros
#define MINGYISHENG_CURRENT_VERSION                       [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]

/// App Store links
#define MINGYISHENG_APP_STORE_LINK_UNIVERSAL              @"http://itunes.apple.com/lookup?id=%@"

/// JSON parsing
#define MINGYISHENG_APP_STORE_RESULTS                     [self.appData valueForKey:@"results"]

#define VERSION_IOS_REVIEWS_URL_FORMAT  @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=917924758"
#define VERSION_IOS7_REVIEWS_URL_FORMAT @"itms-apps://itunes.apple.com/app/id917924758"

@interface TEVersionTools() <UIAlertViewDelegate>
@property (strong, nonatomic) NSDictionary *appData;
@end

@implementation TEVersionTools

// 单例
+ (TEVersionTools *)sharedInstance
{
    static TEVersionTools *versionHelper = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        versionHelper = [[TEVersionTools alloc] init];
    });
    
    return versionHelper;
}

/**
 *  检查你的应用已安装的版本和它在苹果商店的版本是否有冲突
 *  如果有新版本存在，提示用户进行更新
 *  此操作的请求方式为异步请求
 */
- (void)checkVersion
{
    // Asynchronously query iTunes AppStore for publically available version
    NSString *storeString = [NSString stringWithFormat:MINGYISHENG_APP_STORE_LINK_UNIVERSAL, self.appID];
    NSURL *storeURL = [NSURL URLWithString:storeString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:storeURL];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        if ([data length] > 0 && !error) { // Success
            
            self.appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
  
                // All versions that have been uploaded to the AppStore
                NSArray *versionsInAppStore = [MINGYISHENG_APP_STORE_RESULTS valueForKey:@"version"];
                
                if ([versionsInAppStore count]) { // No versions of app in AppStore
                    NSString *currentAppStoreVersion = [versionsInAppStore objectAtIndex:0];
                    [self checkIfDeviceIsSupportedInCurrentAppStoreVersion:currentAppStoreVersion isSynchronous:NO];
                }
            });
        }
    }];
}

/**
 *  检查你的应用已安装的版本和它在苹果商店的版本是否有冲突
 *  如果有新版本存在，提示用户进行更新
 *  此操作的请求方式为同步请求
 */
- (void)checkVersionForSynchronous
{
    NSString *storeString = [NSString stringWithFormat:MINGYISHENG_APP_STORE_LINK_UNIVERSAL, self.appID];
    NSURL *storeURL = [NSURL URLWithString:storeString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:storeURL];
    [request setHTTPMethod:@"GET"];

    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if ([data length] > 0) { // Success
        self.appData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSArray *versionsInAppStore = [MINGYISHENG_APP_STORE_RESULTS valueForKey:@"version"];
        if ([versionsInAppStore count]) { // No versions of app in AppStore
            NSString *currentAppStoreVersion = [versionsInAppStore objectAtIndex:0];
            [self checkIfDeviceIsSupportedInCurrentAppStoreVersion:currentAppStoreVersion isSynchronous:YES];
        }
    }
}

/**
 *  比较当前应用的版本和它在苹果商店的版本
 *  并且当前设备是否在应用所支持的设备列表里
 *
 *  @param currentAppStoreVersion 当前应用在苹果商店的版本
 *  @param isSynchronous          是否是同步请求网络
 */
- (void)checkIfDeviceIsSupportedInCurrentAppStoreVersion:(NSString *)currentAppStoreVersion isSynchronous:(BOOL)isSynchronous
{
    // Current installed version is the newest public version or newer (e.g., dev version)
    if ([MINGYISHENG_CURRENT_VERSION compare:currentAppStoreVersion options:NSNumericSearch] == NSOrderedAscending) {
        
        /*
         This conditional checks to see if the current device is supported.
         If the current device is supported, or if the current device is one of the simulators,
         the update notification alert will be presented to the user. However, if the the device is
         not supported, no alert will be shown, as the current version of the app no longer works on the current device.
         */
        
        NSArray *supportedDevices = [MINGYISHENG_APP_STORE_RESULTS valueForKey:@"supportedDevices"][0];
        NSString *currentDeviceName = [UIDevice supportedDeviceName];
        
        if ([supportedDevices containsObject:currentDeviceName] ||
            [currentDeviceName isEqualToString:[UIDevice simulatorNamePad]] ||
            [currentDeviceName isEqualToString:[UIDevice simulatorNamePhone]]) {
            [self showAlertViewIsUpdate];
        }
    } else {
        if (isSynchronous) {
            [self showAlertViewNoUpdate];
        }  
    }
}

/**
 *  提示用户发现新版本，是否要更新
 */
- (void)showAlertViewIsUpdate
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"更新提示"]
                                                        message:@"发现新版本，是否要更新？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"更新", nil];
    [alertView show];
}

/**
 *  提示用户无更新，你现在的版本是最新的
 */
- (void)showAlertViewNoUpdate
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"提示"]
                                                        message:@"你现在的版本是最新的"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
}

/**
 *  跳转到苹果商店
 */
- (void)launchAppStore
{
    NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", self.appID];
    NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
    [[UIApplication sharedApplication] openURL:iTunesURL];
}

/**
 *  给我评价
 */
- (void)openAppReviews
{
    NSURL *URL = nil;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        URL = [NSURL URLWithString:VERSION_IOS7_REVIEWS_URL_FORMAT];
    }
    else
    {
        URL = [NSURL URLWithString:VERSION_IOS_REVIEWS_URL_FORMAT];
    }
    [[UIApplication sharedApplication] openURL:URL];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [self launchAppStore];
    }
}

@end
