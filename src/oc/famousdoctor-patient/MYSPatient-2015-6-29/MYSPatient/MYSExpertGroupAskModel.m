//
//  MYSExpertGroupAskModel.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-10.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSExpertGroupAskModel.h"

@implementation MYSExpertGroupAskModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"uid": @"expertId",
                                                       @"doctor_name": @"expertName",
                                                       @"pic": @"expertIcon",
                                                       @"qualifications": @"expertTitle",
                                                       @"keshi": @"department",
                                                       @"hid": @"hospitalId",
                                                       @"title": @"hospitalName",
                                                       @"price": @"price",
                                                       @"proid": @"productId"
                                                       }];
}

@end
