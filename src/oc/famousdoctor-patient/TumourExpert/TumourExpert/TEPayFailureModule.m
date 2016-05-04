//
//  TEPayFailureModule.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-19.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEPayFailureModule.h"
#import "TEPayFailureViewController.h"

@implementation TEPayFailureModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[TEPayFailureViewController class] toProtocol:@protocol(TEPayFailureViewControllerProtocol)];
}

@end
