//
//  TEPatientDataModel.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-17.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEPatientDataModel.h"

@implementation TEPatientDataModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"pid": @"patientId",
                                                       @"pmid": @"patientDataId",
                                                       @"pmid_name": @"patientDataName",
                                                       @"audit_status": @"auditState"
                                                       }];
}


@end
