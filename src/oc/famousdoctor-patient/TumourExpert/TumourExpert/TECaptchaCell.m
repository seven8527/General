//
//  TECaptchaCell.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-21.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TECaptchaCell.h"
#import "UIColor+Hex.h"

@implementation TECaptchaCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, 55, 21)];
        _infoLabel.font = [UIFont boldSystemFontOfSize:13];
        _infoLabel.textColor = [UIColor colorWithHex:0x00947d];
        _infoLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_infoLabel];
        
        _valueTextField = [[UITextField alloc] initWithFrame:CGRectMake(85, 7, kScreen_Width - 220, 30)];
        _valueTextField.returnKeyType = UIReturnKeyDone;
        _valueTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _valueTextField.font = [UIFont systemFontOfSize:13];
        _valueTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.contentView addSubview:_valueTextField];
        
        _captchaButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _captchaButton.frame = CGRectMake(kScreen_Width - 128, 7, 88, 30);
        _captchaButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_captchaButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_captchaButton setBackgroundImage:[UIImage imageNamed:@"button_orange.png"] forState:UIControlStateNormal];
        [_captchaButton setBackgroundImage:[UIImage imageNamed:@"button_gray.png"] forState:UIControlStateDisabled];
        [_captchaButton setEnabled:NO];
        [self.contentView addSubview:_captchaButton];
    }
    return self;
}


@end
