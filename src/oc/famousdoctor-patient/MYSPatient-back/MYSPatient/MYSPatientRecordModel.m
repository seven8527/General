//
//  MYSPatientRecordModel.m
//  MYSPatient
//
//  Created by 闫文波 on 15-3-2.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSPatientRecordModel.h"

@implementation MYSPatientRecordModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"medicalId": @"patientRecordID",
                                                       @"department": @"department",
                                                       @"medicalOrg": @"hosptal",
                                                       @"medicalDate": @"patientRecordDate",
                                                       @"diagnosis": @"diagnosis",
                                                       @"attTypeList": @"attList"
                                                       }];
}
@end
