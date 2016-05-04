//
//  TEExpertDetail.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-8.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEExpertDetail.h"

@implementation TEExpertDetail

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"message": @"expertDetail",
                                                       @"messages": @"expertArticles"}];
}

@end
