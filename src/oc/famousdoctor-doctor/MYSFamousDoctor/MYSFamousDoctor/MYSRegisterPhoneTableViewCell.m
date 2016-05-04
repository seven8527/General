//
//  MYSRegisterPhoneTableViewCell.m
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/22.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSRegisterPhoneTableViewCell.h"

@implementation MYSRegisterPhoneTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, 65, 21)];
        _infoLabel.font = [UIFont boldSystemFontOfSize:14];
        _infoLabel.textColor = [UIColor colorFromHexRGB:K333333Color];
        _infoLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_infoLabel];
        
        _quhaoTextField = [[UITextField alloc] initWithFrame:CGRectMake(115, 7, 40, 30)];
        _quhaoTextField.placeholder = @"区号";
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 60000)
        _quhaoTextField.textAlignment = NSTextAlignmentCenter;
#else
        _quhaoTextField.textAlignment = UITextAlignmentCenter;
#endif
        _quhaoTextField.returnKeyType = UIReturnKeyNext;
        _quhaoTextField.clearButtonMode = UITextFieldViewModeNever;
        _quhaoTextField.keyboardType = UIKeyboardTypeNumberPad;
        _quhaoTextField.font = [UIFont systemFontOfSize:13];
        _quhaoTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _quhaoTextField.delegate = self;
        [self.contentView addSubview:_quhaoTextField];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(155, 5, 10, 30)];
        label.font = [UIFont boldSystemFontOfSize:14];
        label.textColor = [UIColor colorFromHexRGB:K333333Color];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"-";
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 60000)
        label.textAlignment = NSTextAlignmentCenter;
#else
        label.textAlignment = UITextAlignmentCenter;
#endif
        [self.contentView addSubview:label];
        
        _dianhuaTextField = [[UITextField alloc] initWithFrame:CGRectMake(165, 7, kScreen_Width - 115 - 35 - 80, 30)];
        _dianhuaTextField.placeholder = @"座机号";
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 60000)
        _dianhuaTextField.textAlignment = NSTextAlignmentCenter;
#else
        _dianhuaTextField.textAlignment = UITextAlignmentCenter;
#endif
        _dianhuaTextField.returnKeyType = UIReturnKeyNext;
        _dianhuaTextField.clearButtonMode = UITextFieldViewModeNever;
        _dianhuaTextField.keyboardType = UIKeyboardTypeNumberPad;
        _dianhuaTextField.font = [UIFont systemFontOfSize:13];
        _dianhuaTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _dianhuaTextField.delegate = self;
        [self.contentView addSubview:_dianhuaTextField];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width - 65, 5, 10, 30)];
        label1.font = [UIFont boldSystemFontOfSize:14];
        label1.textColor = [UIColor colorFromHexRGB:K333333Color];
        label1.backgroundColor = [UIColor clearColor];
        label1.text = @"-";
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 60000)
        label1.textAlignment = NSTextAlignmentCenter;
#else
        label1.textAlignment = UITextAlignmentCenter;
#endif
        [self.contentView addSubview:label1];
        
        _fenjiTextField = [[UITextField alloc] initWithFrame:CGRectMake(kScreen_Width - 55, 7, 40, 30)];
        _fenjiTextField.placeholder = @"分机号";
#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 60000)
        _fenjiTextField.textAlignment = NSTextAlignmentCenter;
#else
        _fenjiTextField.textAlignment = UITextAlignmentCenter;
#endif
        _fenjiTextField.returnKeyType = UIReturnKeyDone;
        _fenjiTextField.clearButtonMode = UITextFieldViewModeNever;
        _fenjiTextField.keyboardType = UIKeyboardTypeNumberPad;
        _fenjiTextField.font = [UIFont systemFontOfSize:13];
        _fenjiTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        _fenjiTextField.delegate = self;
        [self.contentView addSubview:_fenjiTextField];
    }
    return self;
}

@end
