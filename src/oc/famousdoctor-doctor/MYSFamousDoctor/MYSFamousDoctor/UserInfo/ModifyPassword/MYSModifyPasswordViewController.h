//
//  MYSModifyPasswordViewController.h
//  MYSFamousDoctor
//
//  修改密码
//
//  Created by lyc on 15/4/9.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "BaseViewController.h"

@interface MYSModifyPasswordViewController : BaseViewController
{
    // 原密码
    IBOutlet UIView *oldPassView;
    IBOutlet UITextField *oldPassTextFeild;
    // 新密码
    IBOutlet UIView *newPassView1;
    IBOutlet UITextField *newPass1View1TextFeild;
    // 新密码确认
    IBOutlet UIView *newPassView2;
    IBOutlet UITextField *newPass2View1TextFeild;
    // 保存按钮
    IBOutlet UIButton *saveBtn;
}


@end
