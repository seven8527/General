//
//  TEAddPatientModule.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-27.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEAddPatientModule.h"
#import "TEAddPatientViewController.h"

@implementation TEAddPatientModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[TEAddPatientViewController class] toProtocol:@protocol(TEAddPatientViewControllerProtocol)];
}

@end
