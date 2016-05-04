//
//  MYSSearchDoctor.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-3.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSSearchDoctor.h"

@implementation MYSSearchDoctor

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"message.doctors.message": @"doctorArray",
                                                       @"message.doctors.total": @"doctorTotal"
                                                       }];
}

@end
