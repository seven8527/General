//
//  PBJViewController.h
//  
//
//
//  Created by WangBo on 15/8/10.
//  Copyright (c) 2015年 ToMoon. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "NaviCommonViewController.h"

@protocol PBJViewControllerDelegate<NSObject>

-(void)didFinishRecordVideoFile:(NSString *)strVideoPathAndName;

@end

@interface PBJViewController : UIViewController //NaviCommonViewController

@property (nonatomic, assign) id<PBJViewControllerDelegate> delegate;

@end
