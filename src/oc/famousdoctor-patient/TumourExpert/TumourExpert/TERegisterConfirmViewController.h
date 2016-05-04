//
//  TERegisterConfirmViewController.h
//  TumourExpert
//
//  Created by 闫文波 on 14-9-25.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEBaseTableViewController.h"

@interface TERegisterConfirmViewController : TEBaseTableViewController  <UITextFieldDelegate>
@property (nonatomic, copy)  NSString *mobile;
@property (nonatomic, copy)  NSString *password;
@end
