//
//  MYSCaptchaCell.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-8.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSCaptchaCell.h"
#import "UIColor+Hex.h"
#import "UtilsMacro.h"
#import "MYSFoundationCommon.h"
#import "UIImage+Corner.h"

@implementation MYSCaptchaCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorFromHexRGB:KFFFFFFColor];
        
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 14, 20, 20)];
        [self.contentView addSubview:_iconImageView];
        
        _valueTextField = [[UITextField alloc] initWithFrame:CGRectMake(50, 0, kScreen_Width - 70, 48)];
        _valueTextField.returnKeyType = UIReturnKeyDone;
        _valueTextField.backgroundColor = [UIColor clearColor];
        _valueTextField.textColor = [UIColor colorFromHexRGB:K333333Color];
        _valueTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _valueTextField.font = [UIFont systemFontOfSize:13];
        _valueTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.contentView addSubview:_valueTextField];
        
        _captchaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _captchaButton.frame = CGRectMake(kScreen_Width - 103, 7, 88, 30);
        _captchaButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_captchaButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_captchaButton setTitleColor:[UIColor colorFromHexRGB:KFFFFFFColor] forState:UIControlStateNormal];
        UIImage *normalImage = [MYSFoundationCommon buttonImageFromColor:[UIColor colorFromHexRGB:K00A693Color] withButton:_captchaButton];
        [_captchaButton setBackgroundImage:[UIImage createRoundedRectImage:normalImage size:normalImage.size radius:5] forState:UIControlStateNormal];
        
        UIImage *highlightImage = [MYSFoundationCommon buttonImageFromColor:[UIColor colorFromHexRGB:K00907FColor] withButton:_captchaButton];
        [_captchaButton setBackgroundImage:[UIImage createRoundedRectImage:highlightImage size:normalImage.size radius:5] forState:UIControlStateHighlighted];
        [self.contentView addSubview:_captchaButton];
    }
    return self;
}

@end
