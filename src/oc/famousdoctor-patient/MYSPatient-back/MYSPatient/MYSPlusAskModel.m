//
//  MYSPlusAskModel.m
//  MYSPatient
//
//  Created by 吴玉龙 on 15-3-24.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSPlusAskModel.h"

@implementation MYSPlusAskModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"add_time": @"addTime",
                                                       @"doctor_uid": @"doctorID",
                                                       @"is_reply": @"isReply",
                                                       @"pfid": @"pfID",
                                                       @"pid": @"pid",
                                                       @"question_title": @"question",
                                                       @"reply": @"answerModel",
                                                       @"times": @"times",
                                                       @"state": @"state",
                                                       @"type": @"consultType",
                                                       @"uid": @"userID",
                                                       @"view": @"view"
                                                       }];
}
@end
