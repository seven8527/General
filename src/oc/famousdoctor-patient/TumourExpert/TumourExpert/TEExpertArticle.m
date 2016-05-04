//
//  TEExpertArticle.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-4.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEExpertArticle.h"

@implementation TEExpertArticle

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"message": @"article"}];
}

@end
