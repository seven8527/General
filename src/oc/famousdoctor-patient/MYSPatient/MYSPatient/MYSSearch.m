//
//  MYSSearch.m
//  MYSPatient
//
//  Created by 吴玉龙 on 15-2-2.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSSearch.h"

@implementation MYSSearch

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"message.doctors.message": @"doctorArray",
                                                       @"message.doctors.total": @"doctorTotal",
                                                       @"message.diseases.message": @"diseaseArray",
                                                       @"message.diseases.total": @"diseaseTotal"
                                                       }];
}

@end
