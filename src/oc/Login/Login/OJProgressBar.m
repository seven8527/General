//
//  OJProgressBar.m
//  Login
//
//  Created by Owen on 15/6/11.
//  Copyright (c) 2015年 owen. All rights reserved.
//

#import "OJProgressBar.h"

@implementation OJProgressBar
+(instancetype) showHUDAddTo:(UIView *)view  animated:(bool)animated message:(NSString *)message;
{
    OJProgressBar *mbp = [OJProgressBar  showHUDAddedTo:view animated: YES];
    mbp.labelText = message;
    [mbp show:YES];
    return mbp;
}
@end
