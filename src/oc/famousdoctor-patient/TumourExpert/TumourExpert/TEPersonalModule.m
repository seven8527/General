//
//  TEPersonalModule.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-6.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEPersonalModule.h"
#import "TEPersonalViewController.h"

@implementation TEPersonalModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[TEPersonalViewController class] toProtocol:@protocol(TEPersonalViewControllerProtocol)];
}

@end
