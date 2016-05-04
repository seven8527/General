//
//  MYSExpertGroupRecordDetailsModule.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-16.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupRecordDetailsModule.h"
#import "MYSExpertGroupRecordDetailsViewController.h"

@implementation MYSExpertGroupRecordDetailsModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[MYSExpertGroupRecordDetailsViewController  class] toProtocol:@protocol(MYSExpertGroupRecordDetailsViewControllerProtocol)];
}

@end
