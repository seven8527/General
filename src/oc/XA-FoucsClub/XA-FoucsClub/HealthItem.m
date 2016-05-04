//
//  HealthItem.m
//  XA-FoucsClub
//
//  Created by Owen on 15/6/16.
//  Copyright (c) 2015年 owen. All rights reserved.
//

#import "HealthItem.h"

@implementation HealthItem
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"id": @"ids",
                                                       @"name": @"names",
                                                       }];
}
@end
