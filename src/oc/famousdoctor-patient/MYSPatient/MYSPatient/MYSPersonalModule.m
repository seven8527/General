//
//  MYSPersonalModule.m
//  MYSPatient
//
//  Created by 吴玉龙 on 15-1-7.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSPersonalModule.h"
#import "MYSPersonalViewController.h"

@implementation MYSPersonalModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[MYSPersonalViewController class] toProtocol:@protocol(MYSPersonalViewControllerPrototol)];
}

@end
