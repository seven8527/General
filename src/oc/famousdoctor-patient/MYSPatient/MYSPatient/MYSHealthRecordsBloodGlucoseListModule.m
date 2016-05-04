//
//  MYSHealthRecordsBloodGlucoseListModule.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-26.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSHealthRecordsBloodGlucoseListModule.h"
#import "MYSHealthRecordsBloodGlucoseListViewController.h"

@implementation MYSHealthRecordsBloodGlucoseListModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[MYSHealthRecordsBloodGlucoseListViewController  class] toProtocol:@protocol(MYSHealthRecordsBloodGlucoseListViewControllerProtocol)];
}

@end
