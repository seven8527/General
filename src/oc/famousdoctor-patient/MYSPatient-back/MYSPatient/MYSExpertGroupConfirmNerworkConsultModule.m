//
//  MYSExpertGroupConfirmNerworkConsultModule.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-27.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupConfirmNerworkConsultModule.h"
#import "MYSExpertGroupConfirmNetworkConsultViewController.h"

@implementation MYSExpertGroupConfirmNerworkConsultModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[MYSExpertGroupConfirmNetworkConsultViewController  class] toProtocol:@protocol(MYSExpertGroupConfirmNetworkConsultViewControllerProtocol)];
}

@end
