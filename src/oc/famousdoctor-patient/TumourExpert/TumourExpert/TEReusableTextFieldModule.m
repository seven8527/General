//
//  TEReusableTextFieldModule.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-19.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEReusableTextFieldModule.h"
#import "TEReusableTextFieldViewController.h"

@implementation TEReusableTextFieldModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[TEReusableTextFieldViewController class] toProtocol:@protocol(TEReusableTextFieldViewControllerProtocol)];
}

@end
