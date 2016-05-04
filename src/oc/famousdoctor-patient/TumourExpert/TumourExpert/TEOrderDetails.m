//
//  TEOrderDetails.m
//  TumourExpert
//
//  Created by 闫文波 on 14-10-14.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEOrderDetails.h"

@implementation TEOrderDetails
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"data": @"orderDetails",
                                                       @"msg" : @"msg",
                                                        @"state": @"state"
                                                       }];
}
@end
