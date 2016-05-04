//
//  TEEditConsultDetailsModule.m
//  TumourExpert
//
//  Created by 闫文波 on 14-10-10.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEEditConsultDetailsModule.h"
#import "TEEditConsultDetailsViewController.h"

@implementation TEEditConsultDetailsModule
+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[TEEditConsultDetailsViewController class] toProtocol:@protocol(TEEditConsultDetailsViewControllerProtocol)];
}
@end
