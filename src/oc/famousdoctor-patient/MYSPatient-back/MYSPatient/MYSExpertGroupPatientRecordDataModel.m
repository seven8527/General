//
//  MYSExpertGroupPatientRecordDataModel.m
//  MYSPatient
//
//  Created by 闫文波 on 15-3-11.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupPatientRecordDataModel.h"

@implementation MYSExpertGroupPatientRecordDataModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"add_date": @"addData",
                                                       @"c2": @"hospital",
                                                       @"c3": @"department",
                                                       @"c4": @"jianyandan",
                                                       @"c5": @"binglidan",
                                                       @"c7": @"other",
                                                       @"pid": @"patientID",
                                                       @"pmid": @"recordID",
                                                       @"pmid_title": @"recordTitle",
                                                       @"visiting_time": @"vistingTime",
                                                       @"c13": @"diagnosis",
                                                       @"billno":@"orderNumber"
                                                       }];
}
@end
