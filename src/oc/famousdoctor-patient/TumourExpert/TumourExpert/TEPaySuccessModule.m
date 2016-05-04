//
//  TEPaySuccessModule.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-19.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEPaySuccessModule.h"
#import "TEPaySuccessViewController.h"

@implementation TEPaySuccessModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[TEPaySuccessViewController class] toProtocol:@protocol(TEPaySuccessViewControllerProtocol)];
}

@end