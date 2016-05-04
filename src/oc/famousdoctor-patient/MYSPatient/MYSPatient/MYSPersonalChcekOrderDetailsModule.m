//
//  MYSPersonalChcekOrderDetailsModule.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-2.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSPersonalChcekOrderDetailsModule.h"
#import "MYSPersonalCheckOrderDetailsViewController.h"

@implementation MYSPersonalChcekOrderDetailsModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[MYSPersonalCheckOrderDetailsViewController class] toProtocol:@protocol(MYSPersonalCheckOrderDetailsViewControllerPrototol)];
}

@end
