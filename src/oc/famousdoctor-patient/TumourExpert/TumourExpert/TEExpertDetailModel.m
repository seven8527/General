//
//  TEExpertDetailModel.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-8.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEExpertDetailModel.h"

@implementation TEExpertDetailModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"uid": @"expertId",
                                                       @"doctor_name": @"expertName",
                                                       @"pic": @"expertIcon",
                                                       @"qualifications": @"expertTitle",
                                                       @"territory": @"expertForte",
                                                       @"introduce": @"expertIntroduce",
                                                       @"keshi": @"department",
                                                       @"hid": @"hospitalId",
                                                       @"htitle": @"hospitalName"
                                                       }];
}

@end


