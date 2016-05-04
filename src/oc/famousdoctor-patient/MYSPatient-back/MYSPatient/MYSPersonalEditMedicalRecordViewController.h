//
//  MYSPersonalEditMedicalRecordViewController.h
//  MYSPatient
//
//  Created by 闫文波 on 15-2-2.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSBaseTableViewController.h"
#import "MYSExpertGroupPatientRecordDataModel.h"

// 编辑档案
@interface MYSPersonalEditMedicalRecordViewController : MYSBaseTableViewController
@property (nonatomic, copy) NSString *recordID; // 就诊记录ID
@property (nonatomic, strong) MYSExpertGroupPatientRecordDataModel *patientRecordModel;
@property (nonatomic, strong) MYSExpertGroupPatientModel *patientModel;
@end
