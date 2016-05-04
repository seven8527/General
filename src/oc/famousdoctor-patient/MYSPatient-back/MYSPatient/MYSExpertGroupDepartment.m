//
//  MYSExpertGroupDepartment.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-4.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupDepartment.h"

@implementation MYSExpertGroupDepartment

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"message": @"departmentArray",
                                                       @"state": @"state"
                                                       }];
}

@end
