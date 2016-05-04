//
//  TESetttingModule.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-9-24.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TESetttingModule.h"
#import "TESettingViewController.h"

@implementation TESetttingModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[TESettingViewController class] toProtocol:@protocol(TESettingViewControllerProtocol)];
}

@end
