//
//  TEHome.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-7.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEHome.h"

@implementation TEHome

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"focus_map" : @"focusPictures",
                                                       @"pathology": @"departments",
                                                       @"doctor_message": @"experts",
                                                       @"health_message": @"healthInfos",
                                                       @"article_message": @"expertColumns"
                                                       }];
}


@end
