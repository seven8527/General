//
//  TEOfflineConsultModule.m
//  TumourExpert
//
//  Created by 闫文波 on 14-10-9.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEOfflineConsultModule.h"
#import "TEOfflineConsultViewController.h"

@implementation TEOfflineConsultModule
+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[TEOfflineConsultViewController class] toProtocol:@protocol(TEOfflineConsultViewControllerProtocol)];
}

@end
