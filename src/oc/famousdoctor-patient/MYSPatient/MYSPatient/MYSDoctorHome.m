//
//  MYSDoctorHome.m
//  MYSPatient
//
//  Created by 吴玉龙 on 15-2-4.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSDoctorHome.h"

@implementation MYSDoctorHome

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"message": @"introducesModel",
                                                       @"dynamic": @"dynamicArray",
                                                       @"count": @"count"
                                                       }];
}

@end
