//
//  MYSExpertGroupDoctorHomeModule.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-13.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupDoctorHomeModule.h"
#import "MYSExpertGroupDoctorHomeViewController.h"

@implementation MYSExpertGroupDoctorHomeModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[MYSExpertGroupDoctorHomeViewController  class] toProtocol:@protocol(MYSExpertGroupDoctorHomeViewControllerProtocol)];
}

@end
