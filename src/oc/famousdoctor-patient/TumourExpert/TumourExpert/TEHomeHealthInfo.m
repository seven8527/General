//
//  TEHomeHealthInfo.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-10-16.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEHomeHealthInfo.h"

@implementation TEHomeHealthInfo

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"list": @"healthInfos"
                                                       }];
}

@end
