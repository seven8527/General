//
//  TEHealthArchiveDetailModule.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-10-9.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEHealthArchiveDetailModule.h"
#import "TEHealthArchiveDetailViewController.h"

@implementation TEHealthArchiveDetailModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[TEHealthArchiveDetailViewController class] toProtocol:@protocol(TEHealthArchiveDetailViewControllerProtocol)];
}

@end
