//
//  MYSExpertGroupPayFailureViewModule.m
//  MYSPatient
//
//  Created by 闫文波 on 15-3-4.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupPayFailureViewModule.h"
#import "MYSExpertGroupPayFailureViewController.h"

@implementation MYSExpertGroupPayFailureViewModule
+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[MYSExpertGroupPayFailureViewController  class] toProtocol:@protocol(MYSExpertGroupPayFailureViewProtocol)];
}
@end
