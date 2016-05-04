//
//  TEHealthArchiveDataInfoModel.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-10-13.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEHealthArchiveDataInfoModel.h"

@implementation TEHealthArchiveDataInfoModel

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"pid": @"patientId",
                                                       @"pmid": @"patientDataId",
                                                       @"pmid_title": @"patientDataName",
                                                       }];
}


@end
