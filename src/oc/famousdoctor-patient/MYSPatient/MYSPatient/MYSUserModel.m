//
//  MYSUserModel.m
//  MYSPatient
//
//  Created by 闫文波 on 15-1-9.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSUserModel.h"

@implementation MYSUserModel

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
                                                       @"address" : @"detailedAddress",
                                                       @"my_pic": @"pic"
                                                       }];
}

@end
