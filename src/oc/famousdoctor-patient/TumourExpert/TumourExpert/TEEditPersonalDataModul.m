//
//  TEEditPersonalDataModul.m
//  TumourExpert
//
//  Created by 闫文波 on 14-9-26.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEEditPersonalDataModul.h"
#import "TEEditPersonalDataViewController.h"

@implementation TEEditPersonalDataModul

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[TEEditPersonalDataViewController class] toProtocol:@protocol(TEEditPersonalDataViewControllerProtocol)];
}

@end
