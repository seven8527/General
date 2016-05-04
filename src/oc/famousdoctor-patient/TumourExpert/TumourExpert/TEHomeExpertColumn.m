//
//  TEHomeExpertColumn.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-10-16.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEHomeExpertColumn.h"

@implementation TEHomeExpertColumn

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"message": @"articles"
                                                       }];
}

@end
