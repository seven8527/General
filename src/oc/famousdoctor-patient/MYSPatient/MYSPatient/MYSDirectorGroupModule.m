//
//  MYSDirectorGroupModule.m
//  MYSPatient
//
//  Created by 吴玉龙 on 15-3-18.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSDirectorGroupModule.h"
#import "MYSDirectorGroupViewController.h"

@implementation MYSDirectorGroupModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[MYSDirectorGroupViewController  class] toProtocol:@protocol(MYSDirectorGroupViewControllerProtocol)];
}

@end
