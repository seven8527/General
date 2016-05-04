//
//  TEHomeSliderViewController.h
//  TumourExpert
//
//  Created by 闫文波 on 14-9-30.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "ViewPagerController.h"

@interface TEHomeSliderViewController : ViewPagerController
@property (nonatomic, strong) NSArray *expers;
@property (nonatomic, strong) NSArray *healthInfos;
@property (nonatomic, strong) NSArray *expertColumns;
@end
