//
//  TEPersonalLoginView.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-7-8.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEPersonalLoginView.h"
#import "UIColor+Hex.h"
#import "NSString+CalculateTextSize.h"

@interface TEPersonalLoginView ()
@property (nonatomic, strong) UILabel *loginLabel;
@end

@implementation TEPersonalLoginView

#pragma mark - Life Cycle

- (void)setup
{
    self.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.loginLabel];
    
    [self addSubview:self.loginButton];
    
    [self addSubview:self.registerButton];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

#pragma mark - Propertys

- (UILabel *)loginLabel
{
    if (!_loginLabel) {
        _loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, kScreen_Width - 40, 21)];
        _loginLabel.text = @"您尚未登录账号，请登录：";
        _loginLabel.font = [UIFont boldSystemFontOfSize:15];
        _loginLabel.textColor = [UIColor colorWithHex:0x6b6b6b];
    }

    return _loginLabel;
}

- (UIButton *)loginButton
{
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.frame = CGRectMake(20, 57, 133, 35);
        [_loginButton setTitle:@"登    录" forState:UIControlStateNormal];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_loginButton setBackgroundImage:[UIImage imageNamed:@"button_enter.png"] forState:UIControlStateNormal];  
    }
    
    return _loginButton;
}

- (UIButton *)registerButton
{
    if (!_registerButton) {
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _registerButton.frame = CGRectMake(167, 57, 133, 35);
        [_registerButton setTitle:@"注    册" forState:UIControlStateNormal];
        _registerButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_registerButton setBackgroundImage:[UIImage imageNamed:@"button_register.png"] forState:UIControlStateNormal];
    }
    
    return _registerButton;
}

@end
