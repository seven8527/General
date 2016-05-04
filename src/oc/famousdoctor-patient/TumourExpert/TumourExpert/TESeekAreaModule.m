//
//  TESeekAreaModule.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-10-14.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TESeekAreaModule.h"
#import "TESeekAreaViewController.h"

@implementation TESeekAreaModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[TESeekAreaViewController class] toProtocol:@protocol(TESeekAreaViewControllerProtocol)];
}

@end
