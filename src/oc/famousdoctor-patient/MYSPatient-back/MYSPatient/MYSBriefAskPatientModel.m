//
//  MYSBriefAskPatientModel.m
//  MYSPatient
//
//  Created by 吴玉龙 on 15-3-24.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
// 

#import "MYSBriefAskPatientModel.h"

@implementation MYSBriefAskPatientModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"age": @"patientAge",
                                                       @"birthday": @"patientBirthday",
                                                       @"height": @"patientHeight",
                                                       @"identity": @"patientIdentity",
                                                       @"patient_name": @"patientName",
                                                       @"pic": @"patientPic",
                                                       @"pid": @"patientID",
                                                       @"sex": @"patientSex",
                                                       @"uid": @"userID",
                                                       @"weight": @"patientWeight"
                                                       }];
}
@end
