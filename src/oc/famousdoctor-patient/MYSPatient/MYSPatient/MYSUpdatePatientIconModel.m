//
//  MYSUpdatePatientIconModel.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-10.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSUpdatePatientIconModel.h"

@implementation MYSUpdatePatientIconModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"img_url": @"imageUrl",
                                                       @"newurl": @"thumbnailUrl",
                                                       @"state": @"state"
                                                       }];
}

@end
