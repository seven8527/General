//
//  TEHomeHealthInfoListModule.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-10-16.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEHomeHealthInfoListModule.h"
#import "TEHomeHealthInfoListViewController.h"

@implementation TEHomeHealthInfoListModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[TEHomeHealthInfoListViewController class] toProtocol:@protocol(TEHomeHealthInfoListViewControllerProtocol)];
}

@end
