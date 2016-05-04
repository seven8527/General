//
//  TEFeedbackModule.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-27.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEFeedbackModule.h"
#import "TEFeedbackViewController.h"

@implementation TEFeedbackModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[TEFeedbackViewController class] toProtocol:@protocol(TEFeedbackViewControllerProtocol)];
}

@end
