//
//  MYSExpertGroupOfflineConsultModule.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-27.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupOfflineConsultModule.h"
#import "MYSExpertGroupOfflineConsultViewController.h"

@implementation MYSExpertGroupOfflineConsultModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[MYSExpertGroupOfflineConsultViewController  class] toProtocol:@protocol(MYSExpertGroupOfflineConsultViewControllerProtocol)];
}

@end
