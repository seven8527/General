//
//  MYSExpertGroupPatientModel.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-10.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupPatientModel.h"

@implementation MYSExpertGroupPatientModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"pid": @"patientId",
                                                       @"patient_name": @"patientName",
                                                       @"age": @"patientAge",
                                                       @"pic": @"patientIcon",
                                                       @"sex": @"patientSex",
                                                       @"birthday": @"patientBirthday",
                                                       @"identity": @"identity"
                                                       }];
}

@end
