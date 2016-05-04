//
//  MYSDiseasesModule.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-4.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSDiseasesModule.h"
#import "MYSDiseasesViewController.h"

@implementation MYSDiseasesModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[MYSDiseasesViewController class] toProtocol:@protocol(MYSDiseasesViewControllerProtocol)];
}

@end
