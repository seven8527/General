//
//  TEHealthArchiveDetail.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-10-13.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEHealthArchiveDetail.h"

@implementation TEHealthArchiveDetail

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"message": @"userInfo",
                                                       @"patient_means": @"datas"
                                                       }];
}

@end
