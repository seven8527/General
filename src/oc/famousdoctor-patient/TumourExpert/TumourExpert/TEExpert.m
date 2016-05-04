//
//  TEExpert.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-7.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEExpert.h"

@implementation TEExpert

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"message": @"experts"
                                                       }];
}

@end
