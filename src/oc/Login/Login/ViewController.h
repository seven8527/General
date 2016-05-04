//
//  ViewController.h
//  Login
//
//  Created by Owen on 15-6-3.
//  Copyright (c) 2015年 owen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegisterDelegate.h"


@interface ViewController : UIViewController  <registerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userName;
@property (weak, nonatomic) IBOutlet UITextField *passWord;

-(IBAction)btnOpenClicked :(id)sender;

-(void)registed:(RegisterViewController *)sender;
@end

