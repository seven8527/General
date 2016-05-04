//
//  MYSPatientConsultRecordDataModel.m
//  MYSPatient
//
//  Created by 闫文波 on 15-3-10.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSPatientConsultRecordDataModel.h"

@implementation MYSPatientConsultRecordDataModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"patient_pid": @"patientId",
                                                       @"pmid_title": @"name",
                                                       @"c2": @"hospital",
                                                       @"c1": @"date",
                                                       @"c3": @"keshi",
                                                       @"c13": @"zhenduan",
                                                       @"c4": @"jianyandan",
                                                       @"c5": @"baogaodan",
                                                       @"c7": @"qita",
                                                       @"read_image": @"isContainHttp"
                                                       }];
}
@end
