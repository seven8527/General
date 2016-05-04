//
//  MYSExpertGroupConsultAddNewRecordDataModule.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-23.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupConsultAddNewRecordDataModule.h"
#import "MYSExpertGroupConsultAddNewRecordDataViewController.h"

@implementation MYSExpertGroupConsultAddNewRecordDataModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[MYSExpertGroupConsultAddNewRecordDataViewController  class] toProtocol:@protocol(MYSExpertGroupConsultAddNewRecordDataViewControllerProtocol)];
}


@end
