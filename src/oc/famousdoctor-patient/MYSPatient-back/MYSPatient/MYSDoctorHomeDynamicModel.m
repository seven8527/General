//
//  MYSDoctorHomeDynamicModel.m
//  MYSPatient
//
//  Created by 吴玉龙 on 15-2-4.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSDoctorHomeDynamicModel.h"

@implementation MYSDoctorHomeDynamicModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"dcaid": @"dynamicId",
                                                       @"title": @"title",
                                                       @"pic": @"picurl",
                                                       @"add_date": @"addTime"
                                                       }];
}

@end
