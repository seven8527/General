//
//  TEConsultQuestionModule.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-23.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEConsultQuestionModule.h"
#import "TEConsultQuestionViewController.h"

@implementation TEConsultQuestionModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[TEConsultQuestionViewController class] toProtocol:@protocol(TEConsultQuestionViewControllerProtocol)];
}

@end
