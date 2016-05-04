//
//  MYSExpertGroupPatientRecords.m
//  MYSPatient
//
//  Created by 闫文波 on 15-3-11.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupPatientRecords.h"

@implementation MYSExpertGroupPatientRecords
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"message": @"records",
                                                       @"total": @"total"
                                                       }];
}
@end
