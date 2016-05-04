//
//  MYSLginModule.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-8.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSLginModule.h"
#import "MYSLoginViewController.h"

@implementation MYSLginModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[MYSLoginViewController  class] toProtocol:@protocol(MYSLoginViewControllerProtocol)];
}

@end
