//
//  MYSPatientRecords.h
//  MYSPatient
//
//  Created by 闫文波 on 15-3-2.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//


// 咨询就诊记录数组
#import "JSONModel.h"
#import "MYSPatientRecordModel.h"

@interface MYSPatientRecords : JSONModel
@property (nonatomic, strong) NSArray<MYSPatientRecordModel> *patientRecords;
@end
