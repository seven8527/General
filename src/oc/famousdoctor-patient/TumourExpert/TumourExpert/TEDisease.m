//
//  TEDisease.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-6.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEDisease.h"

@implementation TEDisease

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"data": @"diseases"
                                                       }];
}

@end
