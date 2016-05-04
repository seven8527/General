//
//  TEExpertModel.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-16.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEExpertModel.h"

@implementation TEExpertModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"uid": @"expertId",
                                                       @"hdid": @"departmentId",
                                                       @"doctor_name": @"expertName",
                                                       @"province": @"area",
                                                       @"pic": @"expertIcon",
                                                       @"hid": @"hospitalId",
                                                       @"title": @"hospitalName",
                                                       @"qualifications": @"expertTitle",
                                                       @"keshi": @"department",
                                                       @"quenstion_count": @"onlineconsultCount",
                                                       @"phone_count": @"phoneConsultCount",
                                                       @"refer_count": @"offlineconsultCount"
                                                       }];
}

@end

