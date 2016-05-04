//
//  TEPatientBasicDataModel.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-24.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEPatientBasicDataModel.h"

@implementation TEPatientBasicDataModel

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



