//
//  MYSBannerModule.m
//  MYSPatient
//
//  Created by 吴玉龙 on 15-3-24.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSBannerModule.h"
#import "MYSBannerViewController.h"

@implementation MYSBannerModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[MYSBannerViewController  class] toProtocol:@protocol(MYSBannerViewControllerProtocol)];
}

@end
