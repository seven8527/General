//
//  MYSExpertGroupConsultAddNewRecordModule.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-21.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupConsultAddNewRecordModule.h"
#import "MYSExpertGroupConsultAddNewRecordViewController.h"

@implementation MYSExpertGroupConsultAddNewRecordModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[MYSExpertGroupConsultAddNewRecordViewController  class] toProtocol:@protocol(MYSExpertGroupConsultAddNewRecordViewControllerProtocol)];
}

@end
