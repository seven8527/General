//
//  TEChoosePayModeModule.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-18.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEChoosePayModeModule.h"
#import "TEChoosePayModeViewController.h"

@implementation TEChoosePayModeModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[TEChoosePayModeViewController class] toProtocol:@protocol(TEChoosePayModeViewControllerProtocol)];
}

@end
