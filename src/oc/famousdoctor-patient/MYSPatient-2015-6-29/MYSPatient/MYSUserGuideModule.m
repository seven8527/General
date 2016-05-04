//
//  MYSUserGuideModule.m
//  MYSPatient
//
//  Created by 吴玉龙 on 15-3-11.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSUserGuideModule.h"
#import "MYSUserGuideViewController.h"

@implementation MYSUserGuideModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[MYSUserGuideViewController  class] toProtocol:@protocol(MYSUserGuideViewControllerProtocol)];
}

@end
