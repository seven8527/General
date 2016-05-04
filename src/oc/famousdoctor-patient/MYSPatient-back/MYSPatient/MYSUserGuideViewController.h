//
//  MYSUserGuideViewController.h
//  MYSPatient
//
//  Created by 吴玉龙 on 15-3-11.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MYSUserGuideViewControllerDelegate <NSObject>
- (void)willDismissUserGuide;
@end

@interface MYSUserGuideViewController : UIViewController 
@property (nonatomic, weak) id <MYSUserGuideViewControllerDelegate> delegate;
@end
