//
//  TEHomeDepartmentModel.m
//  TumourExpert
//
//  Created by 闫文波 on 14-10-13.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEHomeDepartmentModel.h"

@implementation TEHomeDepartmentModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"pnid": @"depatmentId",
                                                       @"pnid_name": @"departmentName",
                                                       @"pic_url": @"picUrl",
                                                       @"pic_select": @"picSelectUrl"
                                                       }];
}
@end
