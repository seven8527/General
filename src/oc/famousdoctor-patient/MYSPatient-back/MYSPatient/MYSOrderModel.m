//
//  MYSOrderModel.m
//  MYSPatient
//
//  Created by 闫文波 on 15-3-4.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSOrderModel.h"

@implementation MYSOrderModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"billno": @"orderId",
                                                       @"price": @"orderPrice",
                                                       @"pay_success": @"payState",
                                                       @"status": @"orderState",
                                                       @"add_date": @"orderTime",
                                                       @"doctor_name": @"expertName",
                                                       @"qualifications": @"expertTitle",
                                                       @"hititle": @"hospitalName",
                                                       @"pic": @"expertIcon",
                                                       @"product_type": @"orderType",
                                                       @"patient_name": @"patientName",
                                                       @"patient_pic": @"patientPic",
                                                       @"patient_birthday": @"birthday",
                                                       @"patient_sex": @"gender",
                                                       @"doctor_pic": @"doctorPic",
                                                       @"pay_type": @"payType",
                                                       @"pay_price": @"orderRealPrice"
                                                       }];
}

@end
