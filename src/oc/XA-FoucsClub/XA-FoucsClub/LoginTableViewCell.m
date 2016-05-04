//
//  LoginTableViewCell.m
//  XA-FoucsClub
//
//  Created by Owen on 15/6/19.
//  Copyright (c) 2015年 owen. All rights reserved.
//

#import "LoginTableViewCell.h"

@implementation LoginTableViewCell

-(instancetype) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       
        _image = [[UIImageView alloc]initWithFrame:CGRectMake(15, 14, 20, 20)];
        [self.contentView addSubview:_image];
        
        _text = [[UITextField alloc]initWithFrame:CGRectMake(50, 0, SCREEN_WIDTH-75, 48 )];
        _text.returnKeyType = UIReturnKeyDone;
        _text.backgroundColor = [UIColor clearColor];
        _text.textColor =UIColorFromRGB(0xc2c2c2);
        _text.clearButtonMode = UITextFieldViewModeWhileEditing;
        _text.font = [UIFont systemFontOfSize:13];
        _text.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.contentView addSubview:_text];
    }
    return  self;
}

@end
