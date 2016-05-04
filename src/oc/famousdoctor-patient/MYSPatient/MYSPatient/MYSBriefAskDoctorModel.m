//
//  MYSBriefAskDoctorModel.m
//  MYSPatient
//
//  Created by 吴玉龙 on 15-3-24.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSBriefAskDoctorModel.h"

@implementation MYSBriefAskDoctorModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"clinical_title": @"doctorClinical",
                                                       @"department_title": @"doctorDepatrment",
                                                       @"doctor_name": @"doctorName",
                                                       @"uid": @"doctorID",
                                                       @"pic": @"doctorPic"
                                                       }];
}

@end
