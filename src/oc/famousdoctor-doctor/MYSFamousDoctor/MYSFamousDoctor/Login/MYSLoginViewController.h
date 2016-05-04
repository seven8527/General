//
//  MYSLoginViewController.h
//  MYSFamousDoctor
//
//  登录
//
//  Created by Mr.L on 15/4/8.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "BaseViewController.h"

@interface MYSLoginViewController : BaseViewController
{
    // 头像Image
    IBOutlet UIImageView *logoImageView;
    // 输入框View
    IBOutlet UIView *inputView;
    // 账号
    IBOutlet UITextField *usernameTextField;
    // 密码
    IBOutlet UITextField *passwordTextField;
    // 登录按钮
    IBOutlet UIButton *loginBtn;
    // 注册按钮
    IBOutlet UIButton *registerBtn;
}

@end
