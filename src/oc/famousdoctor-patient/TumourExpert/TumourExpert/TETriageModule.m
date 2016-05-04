//
//  TETriageModule.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-6.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TETriageModule.h"
#import "TETriageViewController.h"

@implementation TETriageModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[TETriageViewController class] toProtocol:@protocol(TETriageViewControllerProtocol)];
}

@end
