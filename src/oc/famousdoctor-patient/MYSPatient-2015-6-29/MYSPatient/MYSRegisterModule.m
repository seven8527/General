//
//  MYSRegisterModule.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-8.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSRegisterModule.h"
#import "MYSRegisterViewController.h"

@implementation MYSRegisterModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[MYSRegisterViewController  class] toProtocol:@protocol(MYSRegisterViewControllerProtocol)];
}

@end
