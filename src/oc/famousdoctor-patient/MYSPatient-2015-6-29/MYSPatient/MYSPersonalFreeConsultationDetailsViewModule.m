//
//  MYSPersonalFreeConsultationDetailsViewModule.m
//  MYSPatient
//
//  Created by 闫文波 on 15-3-23.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSPersonalFreeConsultationDetailsViewModule.h"
#import "MYSPersonalFreeConsultationDetailsViewController.h"

@implementation MYSPersonalFreeConsultationDetailsViewModule
+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[MYSPersonalFreeConsultationDetailsViewController class] toProtocol:@protocol(MYSPersonalFreeConsultationDetailsViewControllerProtocol)];
}

@end
