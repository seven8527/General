//
//  TELoginCell.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-21.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TELoginCell.h"

@implementation TELoginCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 13, 18, 18)];
        [self.contentView addSubview:_iconImageView];
        
        _valueTextField = [[UITextField alloc] initWithFrame:CGRectMake(50, 7, kScreen_Width - 70, 30)];
        _valueTextField.returnKeyType = UIReturnKeyDone;
        _valueTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _valueTextField.font = [UIFont systemFontOfSize:13];
        _valueTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.contentView addSubview:_valueTextField];
    }
    return self;
}

@end
