//
//  TEPhoneConsultDetailModel.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-17.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEPhoneConsultDetailModel.h"

@implementation TEPhoneConsultDetailModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"pmid_name": @"dataName",
                                                       @"pmid_status": @"dataState",
                                                       @"audit_status": @"consultState",
                                                       @"billno": @"orderId",
                                                       @"doctor_name": @"expertName",
                                                       @"patient_name": @"patientName",
                                                       @"tel_time": @"referralTime",
                                                       @"billno_addtime": @"orderTime"
                                                       }];
}

@end
