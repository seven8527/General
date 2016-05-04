//
//  MYSRegisterViewController.h
//  MYSPatient
//
//  Created by 闫文波 on 15-1-8.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSBaseTableViewController.h"

@protocol MYSRegisterViewControllerDelegate <NSObject>
- (void)willDismissRegister;
@end

@interface MYSRegisterViewController : MYSBaseTableViewController
@property (nonatomic, assign) BOOL isGuidePortal; // 是否从引导页过来的
@property (nonatomic, weak) id <MYSRegisterViewControllerDelegate> delegate;
@end



