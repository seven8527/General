//
//  TETextConsultModule.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-16.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TETextConsultModule.h"
#import "TETextConsultViewController.h"

@implementation TETextConsultModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[TETextConsultViewController class] toProtocol:@protocol(TETextConsultViewControllerProtocol)];
}

@end
