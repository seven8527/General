//
//  MYSUserInfoManager.m
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/15.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSUserInfoManager.h"

static MYSUserInfoManager *userInfo = nil;

@implementation MYSUserInfoManager

+ (MYSUserInfoManager *)shareInstance
{
    @synchronized(self)
    {
        if (nil == userInfo)
        {
            userInfo = [[MYSUserInfoManager alloc] init];
        }
    }
    return userInfo;
}

- (void)clearnData
{
    userInfo = nil;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithContentsOfFile:USER_INFO_PLIST];
    [dic setObject:@"" forKey:@"close"];
    [dic setObject:@"" forKey:@"cookie"];
    [dic setObject:@"" forKey:@"doctor_type"];
    [dic setObject:@"" forKey:@"email_confirm"];
    [dic setObject:@"" forKey:@"mobile"];
    [dic setObject:@"" forKey:@"mobile_confirm"];
    [dic setObject:@"" forKey:@"nick_name"];
    [dic setObject:@"" forKey:@"state"];
    [dic setObject:@"" forKey:@"uid"];
    [dic setObject:@"" forKey:@"user_type"];
    [dic writeToFile:USER_INFO_PLIST atomically:YES];
}

@end
