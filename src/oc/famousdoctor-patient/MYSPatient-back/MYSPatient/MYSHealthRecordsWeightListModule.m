//
//  MYSHealthRecordsWeightListModule.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-26.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSHealthRecordsWeightListModule.h"
#import "MYSHealthRecordsWeightListViewController.h"

@implementation MYSHealthRecordsWeightListModule
+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[MYSHealthRecordsWeightListViewController  class] toProtocol:@protocol(MYSHealthRecordsWeightListViewControllerProtocol)];
}
@end
