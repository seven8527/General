//
//  TETextConsultDetailModule.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-9.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TETextConsultDetailModule.h"
#import "TETextConsultDetailViewController.h"

@implementation TETextConsultDetailModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[TETextConsultDetailViewController class] toProtocol:@protocol(TETextConsultDetailViewControllerProtocol)];
}

@end
