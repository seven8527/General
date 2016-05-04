//
//  TEEditPatientModule.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-10-9.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEEditPatientModule.h"
#import "TEEditPatientViewController.h"

@implementation TEEditPatientModule


+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[TEEditPatientViewController class] toProtocol:@protocol(TEEditPatientViewControllerProtocol)];
}

@end
