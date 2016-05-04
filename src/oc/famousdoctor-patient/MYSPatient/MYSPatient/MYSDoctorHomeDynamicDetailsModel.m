//
//  MYSDoctorHomeDynamicDetailsModel.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-9.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSDoctorHomeDynamicDetailsModel.h"

@implementation MYSDoctorHomeDynamicDetailsModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"doctorname": @"doctorName",
                                                       @"title": @"title",
                                                       @"contents": @"content",
                                                       @"add_date": @"addTime"
                                                       }];
}

@end
