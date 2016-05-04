//
//  ViewcotrollerModule.m
//  BigNews
//
//  Created by Owen on 15-8-13.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#import "ViewcotrollerModule.h"
#import "ViewController.h"

@implementation ViewcotrollerModule

+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[ViewController  class] toProtocol:@protocol(BNViewControllerProtocol)];
}@end
