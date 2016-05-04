//
//  MYSLoginCell.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-8.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSLoginCell.h"
#import "UtilsMacro.h"
#import "UIColor+Hex.h"

@implementation MYSLoginCell

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
        _valueTextField.textColor = [UIColor colorFromHexRGB:KC2C2C2Color];
        _valueTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _valueTextField.font = [UIFont systemFontOfSize:13];
        _valueTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.contentView addSubview:_valueTextField];
    }
    return self;
}

@end
