//
//  TESeekTumourModule.m
//  TumourExpert
//
//  Created by 闫文波 on 14-9-28.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TESeekTumourModule.h"
#import "TESeekDiseaseViewController.h"

@implementation TESeekTumourModule
+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[TESeekDiseaseViewController class] toProtocol:@protocol(TESeekDiseaseViewControllerProtocol)];
}

@end
