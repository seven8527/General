//
//  MYSExpertGroupDoctor.m
//  MYSPatient
//
//  Created by 吴玉龙 on 15-2-4.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupDoctor.h"

@implementation MYSExpertGroupDoctor

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"message": @"doctorArray",
                                                       @"total_count": @"doctorTotal"
                                                       }];
}


@end
