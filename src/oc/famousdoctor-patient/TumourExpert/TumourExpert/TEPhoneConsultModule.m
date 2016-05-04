//
//  TEPhoneConsultModule.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-16.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEPhoneConsultModule.h"
#import "TEPhoneConsultViewController.h"

@implementation TEPhoneConsultModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[TEPhoneConsultViewController class] toProtocol:@protocol(TEPhoneConsultViewControllerProtocol)];
}

@end
