//
//  BNListOfNewsViewControllerModule.m
//  BigNews
//
//  Created by owen on 15/8/14.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#import "BNListOfNewsViewControllerModule.h"
#import "BNListOfNewsViewController.h"

@implementation BNListOfNewsViewControllerModule
+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[BNListOfNewsViewController  class] toProtocol:@protocol(BNListOfNewsViewControllerProtocol)];
}
@end
