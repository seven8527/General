//
//  MYSPersonalRecordModel.m
//  MYSPatient
//
//  Created by 闫文波 on 15-3-6.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSPersonalRecordModel.h"

@implementation MYSPersonalRecordModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"medicalId": @"patientRecordID",
                                                       @"department": @"department",
                                                       @"medicalOrg": @"hosptal",
                                                       @"medicalDate": @"patientRecordDate",
                                                       @"diagnosis": @"diagnosis",
                                                       @"attachment": @"attList"
                                                       }];
}
@end
