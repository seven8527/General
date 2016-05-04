//
//  TEChoosePatientDataModule.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-18.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEChoosePatientDataModule.h"
#import "TEChoosePatientDataViewController.h"

@implementation TEChoosePatientDataModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[TEChoosePatientDataViewController class] toProtocol:@protocol(TEChoosePatientDataViewControllerProtocol)];
}

@end
