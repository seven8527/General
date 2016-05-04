//
//  TEHomeHealthInfoModel.m
//  TumourExpert
//
//  Created by 闫文波 on 14-10-13.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEHomeHealthInfoModel.h"

@implementation TEHomeHealthInfoModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"advosory_title": @"healthName",
                                                       @"maid": @"healthInfoId"
                                                       }];
}
@end
