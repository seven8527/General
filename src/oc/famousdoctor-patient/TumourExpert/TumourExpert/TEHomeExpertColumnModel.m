//
//  TEHomeExpertColumnModel.m
//  TumourExpert
//
//  Created by 闫文波 on 14-10-13.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEHomeExpertColumnModel.h"

@implementation TEHomeExpertColumnModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"article_title": @"expertConlumnName",
                                                       @"dcaid": @"expertConlumnId"
                                                       }];
}
@end
