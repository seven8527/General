//
//  MYSHealthRecordsBloodPressureListModule.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-25.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSHealthRecordsBloodPressureListModule.h"
#import "MYSHealthRecordsBloodPressureListViewController.h"

@implementation MYSHealthRecordsBloodPressureListModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[MYSHealthRecordsBloodPressureListViewController  class] toProtocol:@protocol(MYSHealthRecordsBloodPressureListViewControllerProtocol)];
}

@end
