//
//  MYSAboutUsModule.m
//  MYSPatient
//
//  Created by 吴玉龙 on 15-1-7.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSAboutUsModule.h"
#import "MYSAboutUsViewController.h"

@implementation MYSAboutUsModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[MYSAboutUsViewController class] toProtocol:@protocol(MYSAboutUsViewControllerProtocol)];
}

@end
