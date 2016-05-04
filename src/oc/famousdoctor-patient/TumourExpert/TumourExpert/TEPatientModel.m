//
//  TEPatientModel.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-16.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEPatientModel.h"

@implementation TEPatientModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"pid": @"patientId",
                                                       @"patient_name": @"patientName"
                                                       }];
}

@end
