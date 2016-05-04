//
//  MYSAddMedicalPlusCell.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-23.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSAddMedicalPlusCell.h"

@implementation MYSAddMedicalPlusCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        // 增加图片
        UIButton *plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        plusButton.frame = CGRectMake(10, 5, 60, 60);
        self.plusButton = plusButton;
        plusButton.userInteractionEnabled = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        plusButton.backgroundColor = [UIColor redColor];
        [self.plusButton setTitle:@"加" forState:UIControlStateNormal];
         plusButton.transform = CGAffineTransformMakeRotation(M_PI/2);
        [self.plusButton setImage:[UIImage imageNamed:@"consult_button_add_"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.plusButton];
    }
    return self;
}

@end
