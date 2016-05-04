//
//  MYSSettingViewController.h
//  MYSPatient
//
//  Created by 闫文波 on 15-1-6.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSBaseTableViewController.h"

@protocol MYSSettingViewControllerDelegate <NSObject>

- (void)clickLogoutButton;

@end

@interface MYSSettingViewController : MYSBaseTableViewController

@property (nonatomic, weak) id <MYSSettingViewControllerDelegate> delegate;
@end
