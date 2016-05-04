//
//  MYSMoreModule.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-5.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSMoreModule.h"
#import "MYSMoreViewController.h"

@implementation MYSMoreModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[MYSMoreViewController  class] toProtocol:@protocol(MYSMoreViewControllerProtocol)];
}

@end
