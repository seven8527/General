//
//  TEAreaModel.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-10-14.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEAreaModel.h"

@implementation TEAreaModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"province_id": @"provinceId",
                                                       @"province_name": @"provinceName"
                                                       }];
}

@end
