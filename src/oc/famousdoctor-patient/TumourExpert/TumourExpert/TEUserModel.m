//
//  TEUserModel.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-16.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEUserModel.h"

@implementation TEUserModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"uid": @"userId",
                                                       @"user_type": @"userType",
                                                       @"nick_name": @"userName",
                                                       @"mobile": @"mobilephone",
                                                       @"email" : @"email",
                                                       @"phone" : @"phone",
                                                       @"real_name" : @"trueName",
                                                       @"sex" : @"gender",
                                                       @"birthday" : @"birthday",
                                                       @"province" : @"province",
                                                       @"city" : @"city",
                                                       @"region" : @"region",
                                                       @"address" : @"detailedAddress"
                                                       }];
}

@end
