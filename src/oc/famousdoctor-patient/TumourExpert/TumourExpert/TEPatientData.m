//
//  TEPatientData.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-17.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEPatientData.h"

@implementation TEPatientData

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"message": @"patientDatas"
                                                       }];
}

@end
