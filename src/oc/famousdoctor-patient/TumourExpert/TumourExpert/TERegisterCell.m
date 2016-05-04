//
//  TERegisterCell.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-21.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TERegisterCell.h"
#import "UIColor+Hex.h"

@implementation TERegisterCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, 65, 21)];
        _infoLabel.font = [UIFont boldSystemFontOfSize:13];
        _infoLabel.textColor = [UIColor colorWithHex:0x00947d];
        _infoLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_infoLabel];
        
        _valueTextField = [[UITextField alloc] initWithFrame:CGRectMake(115, 7, kScreen_Width - 130, 30)];
        _valueTextField.returnKeyType = UIReturnKeyDone;
        _valueTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _valueTextField.font = [UIFont systemFontOfSize:13];
        _valueTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.contentView addSubview:_valueTextField];
    }
    return self;
}

@end
