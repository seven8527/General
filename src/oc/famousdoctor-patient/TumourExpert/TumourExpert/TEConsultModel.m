//
//  TEConsultModel.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-6.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEConsultModel.h"

@implementation TEConsultModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"add_date": @"orderTime",
                                                       @"billno": @"orderNo",
                                                       @"pmid": @"dataId",
                                                       @"pqid": @"questionId",
                                                       @"doctor_uid": @"expertId",
                                                       @"doctor_name": @"expertName",
                                                       @"patient_name": @"patientName",
                                                       @"pay_success": @"isPaySuccess",
                                                       @"status": @"consultState"
                                                       }];
}

@end
