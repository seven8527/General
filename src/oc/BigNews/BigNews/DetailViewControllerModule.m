//
//  DetailViewControllerModule.m
//  BigNews
//
//  Created by owen on 15/8/17.
//  Copyright (c) 2015年 Owen. All rights reserved.
//

#import "DetailViewControllerModule.h"
#import "DetailViewController.h"
#import "Protocols.h"

@implementation DetailViewControllerModule
+(void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[DetailViewController  class] toProtocol:@protocol(DetailViewControllerProtocol)];
}
@end
