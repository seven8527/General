//
//  TEHomeRecommendExpertListModule.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-10-16.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEHomeRecommendExpertListModule.h"
#import "TEHomeRecommendExpertListViewController.h"

@implementation TEHomeRecommendExpertListModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[TEHomeRecommendExpertListViewController class] toProtocol:@protocol(TEHomeRecommendExpertListViewControllerProtocol)];
}

@end
