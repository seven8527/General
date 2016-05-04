//
//  TEPatientDataPreviewModule.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-27.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEPatientDataPreviewModule.h"
#import "TEPatientDataPreviewViewController.h"

@implementation TEPatientDataPreviewModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[TEPatientDataPreviewViewController class] toProtocol:@protocol(TEPatientDataPreviewViewControllerProtocol)];
}

@end