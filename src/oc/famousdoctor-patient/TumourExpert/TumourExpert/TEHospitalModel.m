//
//  TEHospitalModel.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-16.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEHospitalModel.h"

@implementation TEHospitalModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"hid": @"hospitalId",
                                                       @"title": @"hospitalName"
                                                       }];
}

@end
