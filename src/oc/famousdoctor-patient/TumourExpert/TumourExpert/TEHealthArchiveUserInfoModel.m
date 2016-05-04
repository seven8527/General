//
//  TEHealthArchiveUserInfoModel.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-10-13.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEHealthArchiveUserInfoModel.h"

@implementation TEHealthArchiveUserInfoModel

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"file_number": @"archiveNumber",
                                                       @"patient_itentity": @"idCard",
                                                       @"pid": @"patientId",
                                                       @"patient_name": @"patientName"
                                                       }];
}

@end
