//
//  UIDevice+SupportedDevices.m
//
//  Created by Arthur Sabintsev on 10/25/13.
//  Copyright (c) 2013 Arthur Ariel Sabintsev. All rights reserved.
//

#import "UIDevice+SupportedDevices.h"
#import <sys/utsname.h>

@implementation UIDevice (SupportedDevices)

+ (NSString *)machineName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

+ (NSString *)simulatorNamePhone
{
    return @"iPhone Simulator";
}

+ (NSString *)simulatorNamePad
{
    return @"iPad Simulator";
}

+ (NSString *)supportedDeviceName
{
    NSString *deviceName = nil;
    NSString *machineName = [self machineName];
    
    // Model information retrieved from http://theiphonewiki.com/wiki/Models
    if ([machineName isEqualToString:@"iPad1,1"]) deviceName = @"iPad";
    else if ([machineName isEqualToString:@"iPad2,1"]) deviceName = @"iPad 2";
    else if ([machineName isEqualToString:@"iPad2,2"]) deviceName = @"iPad 2";
    else if ([machineName isEqualToString:@"iPad2,3"]) deviceName = @"iPad 2";
    else if ([machineName isEqualToString:@"iPad2,4"]) deviceName = @"iPad 2";
    else if ([machineName isEqualToString:@"iPad3,1"]) deviceName = @"iPad 3";
    else if ([machineName isEqualToString:@"iPad3,2"]) deviceName = @"iPad 3";
    else if ([machineName isEqualToString:@"iPad3,3"]) deviceName = @"iPad 3";
    else if ([machineName isEqualToString:@"iPad3,4"]) deviceName = @"iPad 4";
    else if ([machineName isEqualToString:@"iPad3,5"]) deviceName = @"iPad 4";
    else if ([machineName isEqualToString:@"iPad3,6"]) deviceName = @"iPad 4";
    else if ([machineName isEqualToString:@"iPad4,1"]) deviceName = @"iPad Air";
    else if ([machineName isEqualToString:@"iPad4,2"]) deviceName = @"iPad Air";
    else if ([machineName isEqualToString:@"iPad4,3"]) deviceName = @"iPad Air";
    else if ([machineName isEqualToString:@"iPad5,3"]) deviceName = @"iPad Air 2";
    else if ([machineName isEqualToString:@"iPad5,4"]) deviceName = @"iPad Air 2";
    else if ([machineName isEqualToString:@"iPad2,5"]) deviceName = @"iPad Mini";
    else if ([machineName isEqualToString:@"iPad2,6"]) deviceName = @"iPad Mini";
    else if ([machineName isEqualToString:@"iPad2,7"]) deviceName = @"iPad Mini";
    else if ([machineName isEqualToString:@"iPad4,4"]) deviceName = @"iPad Mini 2";
    else if ([machineName isEqualToString:@"iPad4,5"]) deviceName = @"iPad Mini 2";
    else if ([machineName isEqualToString:@"iPad4,6"]) deviceName = @"iPad Mini 2";
    else if ([machineName isEqualToString:@"iPad4,7"]) deviceName = @"iPad Mini 3";
    else if ([machineName isEqualToString:@"iPad4,8"]) deviceName = @"iPad Mini 3";
    else if ([machineName isEqualToString:@"iPad4,9"]) deviceName = @"iPad Mini 3";
    else if ([machineName isEqualToString:@"iPod1,1"]) deviceName = @"iPod touch";
    else if ([machineName isEqualToString:@"iPod2,1"]) deviceName = @"iPod touch 2G";
    else if ([machineName isEqualToString:@"iPod3,1"]) deviceName = @"iPod touch 3G";
    else if ([machineName isEqualToString:@"iPod4,1"]) deviceName = @"iPod touch 4G";
    else if ([machineName isEqualToString:@"iPod5,1"]) deviceName = @"iPod touch 5G";
    else if ([machineName isEqualToString:@"iPhone1,1"]) deviceName = @"iPhone";
    else if ([machineName isEqualToString:@"iPhone1,2"]) deviceName = @"iPhone 3G";
    else if ([machineName isEqualToString:@"iPhone2,1"]) deviceName = @"iPhone 3GS";
    else if ([machineName isEqualToString:@"iPhone3,1"]) deviceName = @"iPhone 4";
    else if ([machineName isEqualToString:@"iPhone3,2"]) deviceName = @"iPhone 4";
    else if ([machineName isEqualToString:@"iPhone3,3"]) deviceName = @"iPhone 4";
    else if ([machineName isEqualToString:@"iPhone4,1"]) deviceName = @"iPhone 4S";
    else if ([machineName isEqualToString:@"iPhone5,1"]) deviceName = @"iPhone 5";
    else if ([machineName isEqualToString:@"iPhone5,2"]) deviceName = @"iPhone 5";
    else if ([machineName isEqualToString:@"iPhone5,3"]) deviceName = @"iPhone 5c";
    else if ([machineName isEqualToString:@"iPhone5,4"]) deviceName = @"iPhone 5c";
    else if ([machineName isEqualToString:@"iPhone6,1"]) deviceName = @"iPhone 5s";
    else if ([machineName isEqualToString:@"iPhone6,2"]) deviceName = @"iPhone 5s";
    else if ([machineName isEqualToString:@"iPhone7,1"]) deviceName = @"iPhone 6 Plus";
    else if ([machineName isEqualToString:@"iPhone7,2"]) deviceName = @"iPhone 6";
    else if ([machineName isEqualToString:@"i386"]) deviceName = [self simulatorNamePhone]; // iPhone Simulator
    else if ([machineName isEqualToString:@"x86_64"]) deviceName = [self simulatorNamePad]; // iPad Simulator
    else deviceName = @"Unknown";
    
    return deviceName;
}

@end
