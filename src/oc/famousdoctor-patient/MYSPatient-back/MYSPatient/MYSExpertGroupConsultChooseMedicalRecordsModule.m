//
//  MYSExpertGroupConsultChooseMedicalRecordsModule.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-17.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupConsultChooseMedicalRecordsModule.h"
#import "MYSExpertGroupConsultChooseMedicalRecordsViewController.h"

@implementation MYSExpertGroupConsultChooseMedicalRecordsModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[MYSExpertGroupConsultChooseMedicalRecordsViewController  class] toProtocol:@protocol(MYSExpertGroupConsultChooseMedicalRecordsViewControllerProtocol)];
}

@end
