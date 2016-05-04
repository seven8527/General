//
//  MYSPersonalRecords.m
//  MYSPatient
//
//  Created by 闫文波 on 15-3-6.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSPersonalRecords.h"

@implementation MYSPersonalRecords
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"data": @"patientRecords"
                                                       }];
}
@end
