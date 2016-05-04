//
//  MYSDiseaseDetailsModule.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-5.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSDiseaseDetailsModule.h"
#import "MYSDiseaseDetailsViewController.h"

@implementation MYSDiseaseDetailsModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[MYSDiseaseDetailsViewController class] toProtocol:@protocol(MYSDiseaseDetailsViewControllerProtocol)];
}

@end
