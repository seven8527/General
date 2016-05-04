//
//  MYSPersonalOrderDetails.m
//  MYSPatient
//
//  Created by 闫文波 on 15-3-5.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSPersonalOrderDetails.h"

@implementation MYSPersonalOrderDetails
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"data": @"orderDetails",
                                                       @"msg" : @"msg",
                                                       @"state": @"state"
                                                       }];
}
@end
