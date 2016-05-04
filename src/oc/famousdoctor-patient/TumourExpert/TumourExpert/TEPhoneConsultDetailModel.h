//
//  TEPhoneConsultDetailModel.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-17.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

@interface TEPhoneConsultDetailModel : JSONModel
@property (nonatomic, strong) NSString *dataName; // 资料名
@property (nonatomic, assign) int dataState; // 资料状态
@property (nonatomic, assign) int consultState; // 咨询状态
@property (nonatomic, strong) NSString *orderId; // 订单号
@property (nonatomic, strong) NSString *expertName; // 专家姓名
@property (nonatomic, strong) NSString *patientName; // 患者姓名
@property (nonatomic, strong) NSString *referralTime; // 预约时间
@property (nonatomic, strong) NSString *orderTime; // 订单时间
@end
