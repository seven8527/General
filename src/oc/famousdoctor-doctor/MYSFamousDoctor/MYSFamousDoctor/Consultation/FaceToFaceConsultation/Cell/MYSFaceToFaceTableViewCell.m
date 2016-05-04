//
//  MYSFaceToFaceTableViewCell.m
//  MYSFamousDoctor
//
//  Created by lyc on 15/4/19.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSFaceToFaceTableViewCell.h"

@implementation MYSFaceToFaceTableViewCell

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
    
    topAddDate.text = [dic objectForKey:@"add_date"];
    
    NSInteger audit_status = [[dic objectForKey:@"audit_status"] integerValue];
    
    middleBillNo.text = [dic objectForKey:@"billno"];
    middleQueRenTime.text = [dic objectForKey:@"referral_date"];
    middleQiWangTime.text = [dic objectForKey:@"referral_date_user"];
    
    topType.text = [MYSUtils getOderStatus:audit_status];
    if (1 == audit_status)
    {
        middleQueRenTime.text = @"待确定";
    }
    
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
    bottomUserInfo.text = userInfo;
}

- (IBAction)lookBtnClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(cellBtnClick:)])
    {
        [self.delegate cellBtnClick:mDic];
    }
}

@end
