//
//  TEPersonalLogoutView.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-7-8.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEPersonalLogoutView.h"

@implementation TEPersonalLogoutView

- (UIButton *)logoutButton
{
    if (!_logoutButton) {
        _logoutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _logoutButton.frame = CGRectMake(25, 20, 270, 44);
        [_logoutButton setTitle:@"退出登录" forState:UIControlStateNormal];
        _logoutButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_logoutButton setBackgroundImage:[UIImage imageNamed:@"button_red.png"] forState:UIControlStateNormal];
        [self addSubview:_logoutButton];
    }
    
    return _logoutButton;
}

@end
