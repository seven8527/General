//
//  BNHotsViewControllerModule.m
//  BigNews
//
//  Created by Owen on 15-8-14.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#import "BNHotsViewControllerModule.h"
#import "BNHotsViewController.h"

@implementation BNHotsViewControllerModule
+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[BNHotsViewController  class] toProtocol:@protocol(BNHotsViewControllerProtocol)];
}
@end
