//
//  MYSPlusAnswerModel.m
//  MYSPatient
//
//  Created by 吴玉龙 on 15-3-24.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSPlusAnswerModel.h"

@implementation MYSPlusAnswerModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"add_time": @"addTime",
                                                       @"content": @"content",
                                                       @"doctor_uid": @"doctorID",
                                                       @"pfid": @"pfID",
                                                       @"pfrid": @"pfrID",
                                                       @"state": @"state",
                                                       @"type": @"consultType"
                                                       }];
}
@end
