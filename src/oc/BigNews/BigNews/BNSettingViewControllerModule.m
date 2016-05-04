//
//  BNSettingViewControllerModule.m
//  BigNews
//
//  Created by Owen on 15-8-14.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#import "BNSettingViewControllerModule.h"
#import "BNSettingViewController.h"

@implementation BNSettingViewControllerModule
+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[BNSettingViewController  class] toProtocol:@protocol(BNSettingViewControllerProtocol)];
}
@end
