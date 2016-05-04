//
//  TEOrderDetailsModel.m
//  TumourExpert
//
//  Created by 闫文波 on 14-10-14.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEOrderDetailsModel.h"

@implementation TEOrderDetailsModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"bid": @"orderId",
                                                       @"pay_price": @"truePrice",
                                                       @"pay_success": @"payStatue",
                                                       @"pay_type": @"payModeType",
                                                       @"doctor_name": @"expertName",
                                                       @"pmid": @"orderNumber",
                                                       @"title": @"healthFile",
                                                       @"c9": @"symptom",
                                                       @"c10": @"desDetails",
                                                       @"question": @"help",
                                                       @"pid": @"patientID",
                                                       @"status": @"orderState",
                                                       @"pay_date": @"payTime",
                                                       @"doctor_answer": @"expertAnswer",
                                                       @"patient_name": @"patientName",
                                                       @"phone": @"phone",
                                                       @"user_tel_time": @"expectStartTime",
                                                       @"user_tel_time_end": @"expectEndTime",
                                                       @"referral_date_user": @"expectTime",
                                                       @"tel_time": @"actualStartTime",
                                                       @"tel_time_end": @"actualEndTime",
                                                       @"referral_date": @"actualTime"
                                                       }];
}

@end
