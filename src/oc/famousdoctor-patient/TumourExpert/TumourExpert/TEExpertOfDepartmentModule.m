//
//  TEExpertOfDepartmentModule.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-10-13.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEExpertOfDepartmentModule.h"
#import "TEExpertOfDepartmentViewController.h"

@implementation TEExpertOfDepartmentModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[TEExpertOfDepartmentViewController class] toProtocol:@protocol(TEExpertOfDepartmentViewControllerProtocol)];
}

@end
