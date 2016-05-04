//
//  TEConsultReplyModel.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-6.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEConsultReplyModel.h"

@implementation TEConsultReplyModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"question": @"question",
                                                       @"doctor_answer": @"answer",
                                                       @"first_question": @"firstQuestion",
                                                       @"first_doctor_answer": @"firstAnswer",
                                                       @"second_question": @"secondQuestion",
                                                       @"second_doctor_answer": @"secondAnswer",
                                                       @"third_question": @"thirdQuestion",
                                                       @"third_doctor_answer": @"thirdAnswer",
                                                       @"pmid": @"dataId",
                                                       @"pmid_name": @"dataName",
                                                       @"pmid_status": @"dataState",
                                                       @"audit_status": @"consultState"
                                                       }];
}

@end
