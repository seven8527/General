//
//  TEHealthArchivesUserModel.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-9-28.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEHealthArchivesUserModel.h"

@implementation TEHealthArchivesUserModel

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"patient_name": @"name",
                                                       @"patient_itentity": @"idCard",
                                                       @"patient_sex": @"gender",
                                                       @"patient_birthday": @"birthday",
                                                       @"patient_height": @"height",
                                                       @"patient_weight": @"weight"
                                                       }];
}

@end
