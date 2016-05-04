//
//  TETumourDetailModule.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-9.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TETumourDetailModule.h"
#import "TETumourDetailViewController.h"

@implementation TETumourDetailModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[TETumourDetailViewController class] toProtocol:@protocol(TETumourDetailViewControllerProtocol)];
}

@end
