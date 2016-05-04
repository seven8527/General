//
//  MYSExpertGroupDynamicDetailsModule.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-16.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupDynamicDetailsModule.h"
#import "MYSExpertGroupDynamicDetailsViewController.h"

@implementation MYSExpertGroupDynamicDetailsModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[MYSExpertGroupDynamicDetailsViewController  class] toProtocol:@protocol(MYSExpertGroupDynamicDetailsViewControllerProtocol)];
}

@end
