//
//  MYSFeedBackModule.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-6.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSFeedBackModule.h"
#import "MYSFeedBackViewController.h"

@implementation MYSFeedBackModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[MYSFeedBackViewController  class] toProtocol:@protocol(MYSFeedBackViewControllerProtocol)];
}

@end
