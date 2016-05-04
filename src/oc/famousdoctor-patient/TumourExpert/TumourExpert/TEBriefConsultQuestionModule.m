//
//  TEBriefConsultQuestionModule.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-19.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEBriefConsultQuestionModule.h"
#import "TEBriefConsultQuestionViewController.h"

@implementation TEBriefConsultQuestionModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[TEBriefConsultQuestionViewController class] toProtocol:@protocol(TEBriefConsultQuestionViewControllerProtocol)];
}

@end
