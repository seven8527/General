//
//  MYSPersonalPatientRecordDataModel.m
//  MYSPatient
//
//  Created by 闫文波 on 15-3-11.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSPersonalPatientRecordDataModel.h"

@implementation MYSPersonalPatientRecordDataModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"c2": @"hospital",
                                                       @"c3": @"department",
                                                       @"c4": @"jianyandan",
                                                       @"c5": @"binglidan",
                                                       @"c7": @"other",
                                                       @"patient_pid": @"patientID",
                                                       @"pmid": @"recordID",
                                                       @"pmid_title": @"recordTitle",
                                                       @"c1": @"vistingTime",
                                                       @"c13": @"diagnosis"
                                                       }];
}
@end
