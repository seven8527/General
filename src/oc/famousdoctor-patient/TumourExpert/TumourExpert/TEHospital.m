//
//  TEHospital.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-9-30.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEHospital.h"

@implementation TEHospital

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"message": @"hospitals"
                                                       }];
}

@end
