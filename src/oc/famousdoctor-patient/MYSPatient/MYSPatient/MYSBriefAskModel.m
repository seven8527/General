//
//  MYSBriefAskModel.m
//  MYSPatient
//
//  Created by 吴玉龙 on 15-3-24.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSBriefAskModel.h"

@implementation MYSBriefAskModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"doctor": @"doctorModel",
                                                       @"patient": @"patientModel",
                                                       @"reply": @"answerModel",
                                                       @"pfid": @"pfID",
                                                       @"uid": @"userID",
                                                       @"pid": @"patientID",
                                                       @"doctor_uid": @"doctorID",
                                                       @"add_time": @"addTime",
                                                       @"is_reply": @"isReply",
                                                       @"times": @"times",
                                                       @"type": @"type",
                                                       @"view": @"view",
                                                       @"question_title": @"question",
                                                       @"user_view": @"userView"
                                                       }];
}
@end
