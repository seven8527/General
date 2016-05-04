//
//  TEReferralDetailModule.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-17.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEReferralDetailModule.h"
#import "TEReferralDetailViewController.h"

@implementation TEReferralDetailModule
+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[TEReferralDetailViewController class] toProtocol:@protocol(TEReferralDetailViewControllerProtocol)];
}

@end
