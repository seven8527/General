//
//  TEArea.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-10-14.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEArea.h"

@implementation TEArea

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"message": @"areas"
                                                       }];
}

@end
