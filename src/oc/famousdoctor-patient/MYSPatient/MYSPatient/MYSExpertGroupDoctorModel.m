//
//  MYSExpertGroupDoctorModel.m
//  MYSPatient
//
//  Created by 吴玉龙 on 15-2-4.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupDoctorModel.h"

@implementation MYSExpertGroupDoctorModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"doctor_id": @"doctorId",
                                                       @"doctor_name": @"doctorName",
                                                       @"pic": @"headPortrait",
                                                       @"hospital_title": @"hospital",
                                                       @"department_title" : @"department",
                                                       @"clinical_title": @"qualifications",
                                                       @"is_attention": @"attentionState",
                                                       @"doctor_type": @"doctorType"
                                                       }];
}

@end
