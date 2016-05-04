//
//  TEOrderModel.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-16.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEOrderModel.h"

@implementation TEOrderModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"billno": @"orderId",
                                                       @"price": @"orderPrice",
                                                       @"pay_success": @"orderState",
                                                       @"add_date": @"orderTime",
                                                       @"doctor_name": @"expertName",
                                                       @"qualifications": @"expertTitle",
                                                       @"hititle": @"hospitalName",
                                                       @"pic": @"expertIcon",
                                                       @"product_type": @"orderType"
                                                       }];
}

@end