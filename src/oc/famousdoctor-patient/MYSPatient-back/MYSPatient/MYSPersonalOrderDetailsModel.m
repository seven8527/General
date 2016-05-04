//
//  MYSPersonalOrderDetailsModel.m
//  MYSPatient
//
//  Created by 闫文波 on 15-3-5.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSPersonalOrderDetailsModel.h"

@implementation MYSPersonalOrderDetailsModel
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
                                                       @"referral_date": @"actualTime",
                                                       @"hospital_title": @"hospital",
                                                       @"departments_name": @"department"
                                                       }];
}

@end
