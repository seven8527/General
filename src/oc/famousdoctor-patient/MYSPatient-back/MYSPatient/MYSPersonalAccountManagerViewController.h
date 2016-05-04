//
//  MYSPersonalAccountManagerViewController.h
//  MYSPatient
//
//  Created by 闫文波 on 15-2-2.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSBaseTableViewController.h"

@protocol MYSPersonalAccountManagerViewDelegate <NSObject>

- (void)personalAccountManagerChangeInfo;

@end

@interface MYSPersonalAccountManagerViewController : MYSBaseTableViewController
@property (nonatomic, strong) MYSUserModel *userModel;
@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, weak) id <MYSPersonalAccountManagerViewDelegate> delegate;
@end
