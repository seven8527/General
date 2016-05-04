//
//  TETumourModule.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-9.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TETumourModule.h"
#import "TETumourViewController.h"

@implementation TETumourModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[TETumourViewController class] toProtocol:@protocol(TETumourViewControllerProtocol)];
}

@end
