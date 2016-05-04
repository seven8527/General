//
//  MYSHealthRecordsModule.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-11.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSHealthRecordsModule.h"
#import "MYSHealthRecordsViewController.h"

@implementation MYSHealthRecordsModule
+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[MYSHealthRecordsViewController  class] toProtocol:@protocol(MYSHealthRecordsViewControllerProtocol)];
}
@end
