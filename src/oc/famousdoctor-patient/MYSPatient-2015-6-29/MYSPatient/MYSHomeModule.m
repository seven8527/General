//
//  MYSHomeModule.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-4.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSHomeModule.h"
#import "MYSHomeViewController.h"

@implementation MYSHomeModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[MYSHomeViewController  class] toProtocol:@protocol(MYSHomeViewControllerProtocol)];
}

@end
