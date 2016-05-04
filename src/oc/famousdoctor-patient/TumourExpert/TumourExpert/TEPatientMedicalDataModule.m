//
//  TEPatientMedicalDataModule.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-16.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEPatientMedicalDataModule.h"
#import "TEPatientMedicalDataViewController.h"

@implementation TEPatientMedicalDataModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[TEPatientMedicalDataViewController class] toProtocol:@protocol(TEPatientMedicalDataViewControllerProtocol)];
}

@end
