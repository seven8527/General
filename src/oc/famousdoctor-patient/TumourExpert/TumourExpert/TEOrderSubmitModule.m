//
//  TEOrderSubmitModule.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-18.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEOrderSubmitModule.h"
#import "TEOrderSubmitViewController.h"

@implementation TEOrderSubmitModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[TEOrderSubmitViewController class] toProtocol:@protocol(TEOrderSubmitViewControllerProtocol)];
}

@end
