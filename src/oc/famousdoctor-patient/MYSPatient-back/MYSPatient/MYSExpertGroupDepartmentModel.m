//
//  MYSExpertGroupDepartmentModel.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-4.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupDepartmentModel.h"

@implementation MYSExpertGroupDepartmentModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"children": @"childDepartmentArray",
                                                       @"title": @"superDepartmentName",
                                                       @"pnid": @"superDepartmentID"
                                                       }];
}

@end
