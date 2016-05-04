//
//  TEChoosePatientModule.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-18.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEChoosePatientModule.h"
#import "TEChoosePatientViewController.h"

@implementation TEChoosePatientModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[TEChoosePatientViewController class] toProtocol:@protocol(TEChoosePatientViewControllerProtocol)];
}

@end
