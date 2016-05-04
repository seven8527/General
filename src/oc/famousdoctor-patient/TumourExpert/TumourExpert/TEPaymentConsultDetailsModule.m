//
//  TEPaymentConsultDetailsModule.m
//  TumourExpert
//
//  Created by 闫文波 on 14-10-9.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEPaymentConsultDetailsModule.h"
#import "TEPaymentConsultDetailsViewController.h"

@implementation TEPaymentConsultDetailsModule
+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[TEPaymentConsultDetailsViewController class] toProtocol:@protocol(TEPaymentConsultDetailsViewControllerProtocol)];
}

@end