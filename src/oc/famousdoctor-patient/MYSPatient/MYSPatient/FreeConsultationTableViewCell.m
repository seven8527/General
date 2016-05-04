//
//  FreeConsultationTableViewCell.m
//  MYSPatient
//
//  Created by lyc on 15/5/21.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "FreeConsultationTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation FreeConsultationTableViewCell

- (void)awakeFromNib
{
    headImageView.layer.cornerRadius = 10;
    headImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)sendValue:(id)dic
{
    id patient = [dic objectForKey:@"patient"];
    if ([Utils checkObjNoNull:patient])
    {
        NSString *pic = [patient objectForKey:@"pic"];
        if ([Utils checkObjIsNull:pic])
        {
            [headImageView sd_setImageWithURL:[NSURL URLWithString:[patient objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"favicon_man"]];
        } else {
            headImageView.image = [UIImage imageNamed:@"favicon_man"];
        }
        
        NSString *nameValStr = @"";
        NSString *name = [patient objectForKey:@"patient_name"];
        if ([Utils checkObjNoNull:name] && ![@"" isEqualToString:name])
        {
            nameValStr = name;
        } else {
            nameValStr = @"未知";
        }
        NSInteger sex = [[Utils checkObjIsNull:[patient objectForKey:@"sex"]] integerValue];
        if (1 == sex)
        {
            nameValStr = [NSString stringWithFormat:@"%@ 男",nameValStr];
        } else {
            nameValStr = [NSString stringWithFormat:@"%@ 女",nameValStr];
        }
        NSInteger age = [[Utils checkObjIsNull:[patient objectForKey:@"age"]] integerValue];
        nameValStr = [NSString stringWithFormat:@"%@ %ld岁",nameValStr, (long)age];
        
        nameLabel.text = nameValStr;
    } else {
        headImageView.image = [UIImage imageNamed:@"favicon_man"];
        nameLabel.text = @"未知 女 0岁";
    }
    
    newReplyLabel.text = [Utils checkObjIsNull:[dic objectForKey:@"question_title"]];
    timeLabel.text = [Utils checkObjIsNull:[dic objectForKey:@"receive"]];
}

@end
