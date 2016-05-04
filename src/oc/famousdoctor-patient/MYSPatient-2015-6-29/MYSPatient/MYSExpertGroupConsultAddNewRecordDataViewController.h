//
//  MYSExpertGroupConsultAddNewRecordDataViewController.h
//  MYSPatient
//
//  Created by 闫文波 on 15-1-21.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSBaseTableViewController.h"

@interface MYSExpertGroupConsultAddNewRecordDataViewController : MYSBaseTableViewController
@property (nonatomic, strong) MYSExpertGroupPatientModel *patientModel;
//@property (nonatomic, copy) NSString *time;
//@property (nonatomic, copy) NSString *hospital;
//@property (nonatomic, copy) NSString *keshi;
//@property (nonatomic, copy) NSString *zhenduan;
@property (nonatomic, strong) NSString *patientDataId; // 患者资料id
@end
