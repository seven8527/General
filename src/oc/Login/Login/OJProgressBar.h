//
//  OJProgressBar.h
//  Login
//
//  Created by Owen on 15/6/11.
//  Copyright (c) 2015年 owen. All rights reserved.
//

#import "ViewController.h"
#import "MBProgressHUD.h"

@interface OJProgressBar : MBProgressHUD


+(instancetype) showHUDAddTo:(UIView *)view  animated:(bool)animated  message:(NSString *)message;

@end
