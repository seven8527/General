//
//  MYSSearchDisease.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-3.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSSearchDisease.h"

@implementation MYSSearchDisease

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"message.diseases.message": @"diseaseArray",
                                                       @"message.diseases.total": @"diseaseTotal"
                                                       }];
}


@end
