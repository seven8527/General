//
//  AlertUtil.m
//  Login
//
//  Created by Owen on 15-6-3.
//  Copyright (c) 2015年 owen. All rights reserved.
//

#import "OJAlertUtil.h"


@implementation OJAlertUtil
/**
 *  显示一个对话框，只有一个按钮提示
 *
 *  @param message 需要显示的消息
 */
+(void)showAlert:(NSString*)message
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
}
@end
