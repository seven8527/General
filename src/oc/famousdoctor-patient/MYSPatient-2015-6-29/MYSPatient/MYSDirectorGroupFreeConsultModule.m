//
//  MYSDirectorGroupFreeConsultModule.m
//  MYSPatient
//
//  Created by 闫文波 on 15-3-19.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSDirectorGroupFreeConsultModule.h"
#import "MYSDirectorGroupFreeConsultViewController.h"

@implementation MYSDirectorGroupFreeConsultModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[MYSDirectorGroupFreeConsultViewController class] toProtocol:@protocol(MYSDirectorGroupFreeConsultViewControllerProtocol)];
}

@end
