//
//  MYSExpertGroupPhoneConsultModule.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-27.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupPhoneConsultModule.h"
#import "MYSExpertGroupPhoneConsultViewController.h"

@implementation MYSExpertGroupPhoneConsultModule
+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[MYSExpertGroupPhoneConsultViewController  class] toProtocol:@protocol(MYSExpertGroupPhoneConsultViewControllerProtocol)];
}

@end
