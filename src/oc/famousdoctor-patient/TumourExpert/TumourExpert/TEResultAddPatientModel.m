//
//  TEResultAddPatientModel.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-10-10.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEResultAddPatientModel.h"

@implementation TEResultAddPatientModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"pid": @"patientId"
                                                       }];
}


@end
