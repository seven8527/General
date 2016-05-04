//
//  TEConsult.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-6.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEConsult.h"

@implementation TEConsult

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"message": @"consults"
                                                       }];
}

@end
