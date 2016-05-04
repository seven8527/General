//
//  TEOrderModel.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-16.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

@protocol TEOrderModel @end

// 订单
@interface TEOrderModel : JSONModel
@property (nonatomic, strong) NSString *orderId; // 订单编号
@property (nonatomic, strong) NSString *orderPrice; // 订单价格
@property (nonatomic, assign) int orderState; // 订单状态(0:未支付, 1:已支付)
@property (nonatomic, strong) NSString *orderTime; // 订单时间
@property (nonatomic, strong) NSString *expertName; // 专家姓名
@property (nonatomic, strong) NSString *expertIcon; // 专家头像
@property (nonatomic, strong) NSString *expertTitle; // 专家职称
@property (nonatomic, strong) NSString *hospitalName; // 医院名称
@property (nonatomic, assign) int orderType; // 订单类型
@end
