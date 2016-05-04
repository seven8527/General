//
//  MYSHealthRecordsBloodsGlucoseModule.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-25.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSHealthRecordsBloodsGlucoseModule.h"
#import "MYSHealthRecordsBloodGlucoseViewController.h"

@implementation MYSHealthRecordsBloodsGlucoseModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[MYSHealthRecordsBloodGlucoseViewController  class] toProtocol:@protocol(MYSHealthRecordsBloodGlucoseViewControllerProtocol)];
}

@end
