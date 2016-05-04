//
//  MYSSearchModule.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-9.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSSearchModule.h"
#import "MYSSearchViewController.h"

@implementation MYSSearchModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[MYSSearchViewController  class] toProtocol:@protocol(MYSSearchViewControllerProtocol)];
}

@end
