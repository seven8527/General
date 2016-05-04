//
//  TEOrder.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-7.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEOrder.h"

@implementation TEOrder

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"message": @"orders"
                                                       }];
}

@end
