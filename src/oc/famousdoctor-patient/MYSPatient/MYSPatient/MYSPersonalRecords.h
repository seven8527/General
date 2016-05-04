//
//  MYSPersonalRecords.h
//  MYSPatient
//
//  Created by 闫文波 on 15-3-6.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

// 个人中心就诊记录数组

#import "JSONModel.h"
#import "MYSPersonalRecordModel.h"

@interface MYSPersonalRecords : JSONModel
@property (nonatomic, strong) NSArray<MYSPersonalRecordModel> *patientRecords;
@end
