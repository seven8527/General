//
//  MYSExpertGroupConsultSelectUserCell.h
//  MYSPatient
//
//  Created by 闫文波 on 15-1-17.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYSExpertGroupPatientModel.h"

@interface MYSExpertGroupConsultSelectUserCell : UITableViewCell
@property (nonatomic, strong) id model;
@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, assign) BOOL isHadNameLabel;
@property (nonatomic, weak) UIImageView *iconImageView;
@property (nonatomic, weak) UIImage *patientPic; // 患者头像
@property (nonatomic, strong) MYSExpertGroupPatientModel *patientModel;

@end
