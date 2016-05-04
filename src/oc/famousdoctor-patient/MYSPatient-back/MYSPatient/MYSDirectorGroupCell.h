//
//  MYSDirectorGroupCell.h
//  MYSPatient
//
//  Created by 吴玉龙 on 15-3-18.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYSSearchDoctorModel.h"
#import "MYSExpertGroupDoctorModel.h"

@interface MYSDirectorGroupCell : UITableViewCell
@property (nonatomic, strong) MYSSearchDoctorModel *doctorModel; // 搜索
@property (nonatomic, weak) UIButton *concerneButton;
@property (nonatomic, weak) UILabel *concerneLabel;
@property (nonatomic, strong) MYSExpertGroupDoctorModel *expertGroupDoctorModel; //名医圈
@end
