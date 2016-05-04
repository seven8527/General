//
//  TEReferralDetailModel.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-17.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEReferralDetailModel.h"

@implementation TEReferralDetailModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"pmid_name": @"dataName",
                                                       @"pmid_status": @"dataState",
                                                       @"audit_status": @"consultState",
                                                       @"billno": @"orderId",
                                                       @"doctor_name": @"expertName",
                                                       @"patient_name": @"patientName",
                                                       @"referral_date": @"referralTime",
                                                       @"billno_addtime": @"orderTime",
                                                       @"referral_flow": @"referralFlow"
                                                       }];
}

@end
