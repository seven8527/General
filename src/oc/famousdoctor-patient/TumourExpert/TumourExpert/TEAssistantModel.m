//
//  TEAssistantModel.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-10.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEAssistantModel.h"

@implementation TEAssistantModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"daid": @"assistantId",
                                                       @"name": @"assistantName"
                                                       }];
}

@end
