//
//  MYSExpertGroupConsultChooseUserCell.h
//  MYSPatient
//
//  Created by 闫文波 on 15-1-17.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYSExpertGroupPatientModel.h"

@interface MYSExpertGroupConsultChooseUserCell : UITableViewCell
@property (nonatomic, weak) UIButton *checkButton;
@property (nonatomic, strong) MYSExpertGroupPatientModel *patientModel;
@end
