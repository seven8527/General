//
//  MYSSearchDoctorModel.m
//  MYSPatient
//
//  Created by 吴玉龙 on 15-2-2.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSSearchDoctorModel.h"

@implementation MYSSearchDoctorModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"uid": @"doctorId",
                                                       @"doctor_name": @"doctorName",
                                                       @"pic": @"headPortrait",
                                                       @"hospital_title": @"hospital",
                                                       @"department_title" : @"department",
                                                       @"clinical_title": @"qualifications",
                                                       @"doctor_type": @"doctorType"
                                                       }];
}

@end
