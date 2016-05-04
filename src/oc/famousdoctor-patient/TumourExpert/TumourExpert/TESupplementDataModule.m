//
//  TESupplementDataModule.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-26.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TESupplementDataModule.h"
#import "TESupplementDataViewController.h"

@implementation TESupplementDataModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[TESupplementDataViewController class] toProtocol:@protocol(TESupplementDataViewControllerProtocol)];
}

@end
