//
//  TEExpertArticleModel.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-8.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEExpertArticleModel.h"

@implementation TEExpertArticleModel

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"dcaid": @"articleId",
                                                       @"title": @"title",
                                                       @"doctor_name": @"author",
                                                       @"add_date": @"publishTime",
                                                       @"contents": @"content"
                                                       }];
}

@end
