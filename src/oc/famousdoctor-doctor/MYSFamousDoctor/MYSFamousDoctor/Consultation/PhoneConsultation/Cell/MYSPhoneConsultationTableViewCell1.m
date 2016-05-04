//
//  MYSPhoneConsultationTableViewCell1.m
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/13.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSPhoneConsultationTableViewCell1.h"

@implementation MYSPhoneConsultationTableViewCell1

- (void)awakeFromNib
{
    lookBtn.layer.borderWidth = 0.5;
    lookBtn.layer.borderColor = [[UIColor colorWithRed:0/255.0f green:164/255.0f blue:143/255.0f alpha:1]CGColor];
    lookBtn.layer.cornerRadius = 3;
    
    bgImageView.image = [[UIImage imageNamed:@"zoe_bg_white_"] resizableImageWithCapInsets:UIEdgeInsetsMake(50, 2, 10, 2) resizingMode:UIImageResizingModeTile];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)sendValue:(id)dic
{
    mDic = dic;
    
    timeDateLabel.text = [dic objectForKey:@"add_date"];
    
    billNoLabel.text = [dic objectForKey:@"billno"];
    qiWangTimeLabel.text = [NSString stringWithFormat:@"%@~%@", [dic objectForKey:@"user_tel_time"], [dic objectForKey:@"user_tel_time_end"]];
    id patient = [dic objectForKey:@"patient"];
    NSString *pName = [patient objectForKey:@"patient_name"];
    // 患者性别
    NSString *pSex = @"男";
    if ([@"0" isEqualToString:[patient objectForKey:@"sex"]])
    {
        pSex = @"女";
    }
    // 患者年龄
    NSString *pAge = [NSString stringWithFormat:@"%@岁", [MYSUtils getAgeFromBirthday:[patient objectForKey:@"birthday"]]];
    NSString *userInfo = [NSString stringWithFormat:@"%@  %@  %@", pName, pSex, pAge];
    userInfoLabel.text = userInfo;
}

/**
 *  查看病历按钮点击事件
 */
- (IBAction)lookBtnClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(cell1BtnClick:)])
    {
        [self.delegate cell1BtnClick:mDic];
    }
}

@end
