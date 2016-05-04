//
//  EXDialogueDetailViewControllerModule.m
//  Express
//
//  Created by owen on 15/11/12.
//  Copyright © 2015年 owen. All rights reserved.
//

#import "EXDialogueDetailViewControllerModule.h"
#import "EXDialogueDetailViewController.h"

@implementation EXDialogueDetailViewControllerModule
+ (void)load
{
    JSObjectionInjector *injector = [JSObjection defaultInjector];
    injector = injector ? : [JSObjection createInjector];
    injector = [injector withModule:[[self alloc] init]];
    [JSObjection setDefaultInjector:injector];
}

- (void)configure
{
    [self bindClass:[EXDialogueDetailViewController class] toProtocol:@protocol(EXDialogueDetailViewControllerProtocol)];
}
@end
