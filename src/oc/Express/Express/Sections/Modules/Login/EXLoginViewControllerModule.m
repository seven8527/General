//
//  EXLoginViewControllerModule.m
//  Express
//
//  Created by owen on 15/11/3.
//  Copyright © 2015年 owen. All rights reserved.
//

#import "EXLoginViewControllerModule.h"
#import "EXLoginViewController.h"

@implementation EXLoginViewControllerModule
+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[EXLoginViewController  class] toProtocol:@protocol(EXLoginViewContollerProtocol)];
}

@end
