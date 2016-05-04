//
//  TEAskModel.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-10.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEAskModel.h"

@implementation TEAskModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"uid": @"expertId",
                                                       @"doctor_name": @"expertName",
                                                       @"pic": @"expertIcon",
                                                       @"qualifications": @"expertTitle",
                                                       @"keshi": @"department",
                                                       @"hid": @"hospitalId",
                                                       @"title": @"hospitalName",
                                                       @"price": @"price",
                                                       @"proid": @"productId"
                                                       }];
}

@end
