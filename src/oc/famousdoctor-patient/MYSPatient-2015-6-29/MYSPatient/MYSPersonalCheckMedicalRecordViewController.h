//
//  MYSPersonalCheckMedicalRecordViewController.h
//  MYSPatient
//
//  Created by 闫文波 on 15-2-2.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSBaseTableViewController.h"

@interface MYSPersonalCheckMedicalRecordViewController : MYSBaseTableViewController
@property (nonatomic, strong) MYSExpertGroupPatientModel *patientModel;
@property (nonatomic, copy) NSString *medicalId;
@property (nonatomic, copy) NSString *orderNumber;
@end
