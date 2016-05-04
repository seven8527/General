//
//  MYSOrderModel.h
//  MYSPatient
//
//  Created by 闫文波 on 15-3-4.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

@protocol MYSOrderModel @end

@interface MYSOrderModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *orderId; // 订单编号
@property (nonatomic, copy) NSString<Optional> *orderPrice; // 订单价格realPrice
@property (nonatomic, copy) NSString<Optional> *orderRealPrice; // 我的订单里的价格
@property (nonatomic, assign) int payState; // 支付状态 (0:未支付, 1:已支付)
@property (nonatomic, assign) int orderState; // 订单状态
@property (nonatomic, copy) NSString<Optional> *orderTime; // 订单时间
@property (nonatomic, copy) NSString<Optional> *expertName; // 专家姓名
@property (nonatomic, copy) NSString<Optional> *expertIcon; // 专家头像
@property (nonatomic, copy) NSString<Optional> *expertTitle; // 专家职称
@property (nonatomic, copy) NSString<Optional> *hospitalName; // 医院名称
@property (nonatomic, copy) NSString<Optional> *patientName; // 患者姓名
@property (nonatomic, assign) int orderType; // 订单类型  咨询类型（0 网络咨询 1 电话咨询 2 面对面咨询）
@property (nonatomic, copy) NSString<Optional> *patientPic; //患者头像
@property (nonatomic, copy) NSString<Optional> *birthday; // 患者生日
@property (nonatomic, copy) NSString<Optional> *gender; // 患者性别
@property (nonatomic, copy) NSString<Optional> *doctorPic; // 医生头像
@property (nonatomic, copy) NSString<Optional> *payType; //支付方式 支付类型 1=支付宝 2=网银 3=网银转账 4=邮局汇款 5= 其他
@end
