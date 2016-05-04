//
//  TESearchResultModule.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-23.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TESearchResultModule.h"
#import "TESearchResultViewController.h"

@implementation TESearchResultModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[TESearchResultViewController class] toProtocol:@protocol(TESearchResultViewControllerProtocol)];
}

@end
