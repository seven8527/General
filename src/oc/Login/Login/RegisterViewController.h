//
//  RegisterViewController.h
//  Login
//
//  Created by Owen on 15/6/8.
//  Copyright (c) 2015年 owen. All rights reserved.
//

#import "ViewController.h"
#import "RegisterDelegate.h"
@class RegisterViewController;



@interface RegisterViewController : UIViewController
@property (nonatomic,assign)id<registerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *pwd;
@property (weak, nonatomic) IBOutlet UITextField *pwd1;
- (IBAction)RegisterBtnClicked:(id)sender;
@end
