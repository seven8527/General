//
//  TEAssistant.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-10.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEAssistant.h"

@implementation TEAssistant

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"message": @"assistants"
                                                       }];
}

@end
