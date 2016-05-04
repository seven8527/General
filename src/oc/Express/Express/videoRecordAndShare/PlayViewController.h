//
//  PlayViewController.h
//
//
//  Created by WangBo on 15/8/10.
//  Copyright (c) 2015年 ToMoon. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "NaviCommonViewController.h"

@interface PlayViewController : UIViewController//: NaviCommonViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withVideoFileURL:(NSURL *)videoFileURL;
- (id)init:(NSURL *)videoFileURL;

+(UIImage *)getImage:(NSString *)videoURL;

@end
