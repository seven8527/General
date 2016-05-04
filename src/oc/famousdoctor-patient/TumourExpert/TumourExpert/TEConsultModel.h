//
//  TEConsultModel.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-6.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

@protocol TEConsultModel @end

// 我的咨询
@interface TEConsultModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *orderTime; // 订单时间
@property (nonatomic, strong) NSString<Optional> *orderNo; // 订单号
@property (nonatomic, strong) NSString<Optional> *dataId; // 资料id
@property (nonatomic, strong) NSString<Optional> *questionId; // 咨询问题id
@property (nonatomic, strong) NSString<Optional> *expertId; // 专家id
@property (nonatomic, strong) NSString<Optional> *expertName; // 专家姓名
@property (nonatomic, strong) NSString<Optional> *patientName; // 患者姓名
@property (nonatomic, assign) int isPaySuccess; // 是否支付成功
@property (nonatomic, assign) int consultState; // 咨询状态
@end

