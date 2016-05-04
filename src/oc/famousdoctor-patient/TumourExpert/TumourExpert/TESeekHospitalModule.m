//
//  TESeekHospitalModule.m
//  TumourExpert
//
//  Created by 闫文波 on 14-9-28.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TESeekHospitalModule.h"
#import "TESeekHospitalViewController.h"

@implementation TESeekHospitalModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[TESeekHospitalViewController class] toProtocol:@protocol(TESeekHospitalViewControllerProtocol)];
}


@end
