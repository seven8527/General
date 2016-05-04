//
//  TEPatient.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-10.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEPatient.h"

@implementation TEPatient

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"message": @"patients"
                                                       }];
}

@end
