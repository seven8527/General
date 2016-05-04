//
//  MYSPersonalChangePasswordModule.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-4.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSPersonalChangePasswordModule.h"
#import "MYSPersonalChangePasswordViewController.h"

@implementation MYSPersonalChangePasswordModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[MYSPersonalChangePasswordViewController class] toProtocol:@protocol(MYSPersonalChangePasswordViewControllerProtocol)];
}

@end
