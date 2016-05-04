//
//  TEExpertColumn.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-8.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEExpertColumn.h"

@implementation TEExpertColumn

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"message": @"articles"
                                                       }];
}

@end
