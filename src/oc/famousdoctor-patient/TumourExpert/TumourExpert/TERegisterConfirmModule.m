//
//  TERegisterConfirmModule.m
//  TumourExpert
//
//  Created by 闫文波 on 14-9-25.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TERegisterConfirmModule.h"
#import "TERegisterConfirmViewController.h"


@implementation TERegisterConfirmModule
+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[TERegisterConfirmViewController class] toProtocol:@protocol(TERegisterConfirmViewControllerProtocol)];
}

@end
