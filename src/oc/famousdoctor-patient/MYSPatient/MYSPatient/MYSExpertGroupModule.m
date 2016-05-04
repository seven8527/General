//
//  MYSExpertGroupModule.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-12.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupModule.h"
#import "MYSExpertGroupViewController.h"

@implementation MYSExpertGroupModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[MYSExpertGroupViewController  class] toProtocol:@protocol(MYSExpertGroupViewControllerProtocol)];
}


@end
