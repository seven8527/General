//
//  MYSExpertGroupChildDepartmentModel.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-4.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupChildDepartmentModel.h"

@implementation MYSExpertGroupChildDepartmentModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"pnid": @"departmentID",
                                                       @"title": @"departmentName"
                                                       }];
}

@end
