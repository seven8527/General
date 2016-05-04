//
//  TEHealthInfoDetailModel.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-10-16.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEHealthInfoDetailModel.h"

@implementation TEHealthInfoDetailModel

+(JSONKeyMapper *)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"article_title": @"healthInfoTitle",
                                                       @"contents": @"healthInfoContent"
                                                       }];
}

@end
