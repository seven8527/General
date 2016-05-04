//
//  MYSThirdLoginViewController.h
//  MYSPatient
//
//  Created by lyc on 15/5/15.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSBaseViewController.h"
#import "MYSLoginViewController.h"

@protocol MYSThirdLoginViewControllerDelegate <NSObject>

- (void)thirdLoginSuccess;

@end

@interface MYSThirdLoginViewController : MYSBaseViewController
{
    // 手机号View
    IBOutlet UIView *phoneView;
    IBOutlet UITextField *phoneTextField;
    
    // 验证码View
    IBOutlet UIView *codeView;
    IBOutlet UITextField *codeTextField;
    
    // 获取验证码按钮
    IBOutlet UIButton *codeBtn;
    // 确定按钮
    IBOutlet UIButton *okBtn;
    
    
    NSString *mOpenID;
    NSString *mType;
    
    
    Class mSource; // 来源
}

@property (assign, nonatomic)id<MYSThirdLoginViewControllerDelegate> delegate;

/**
 *  传递参数
 *
 *  @param openId 第三方平台用户id
 *  @param type   0=qq 1=微博
 */
- (void)sendValue:(NSString *)openId type:(NSString *)type source:(Class)source;

@end
