//
//  MYSPersonalOrderDetailsModel.h
//  MYSPatient
//
//  Created by 闫文波 on 15-3-5.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

@protocol MYSPersonalOrderDetailsModel @end

@interface MYSPersonalOrderDetailsModel : JSONModel
@property (nonatomic, strong) NSString <Optional>*orderId; // 订单id
@property (nonatomic, strong) NSString <Optional>*truePrice; // 实际支付价格
@property (nonatomic, strong) NSString <Optional>*payStatue; // 支付状态 (0: 未支付, 1:支付)
@property (nonatomic, strong) NSString <Optional>*payModeType; //支付类型 (1:支付宝, 2:网银, 3:网银转账, 4:邮局汇款, 5:其他)
@property (nonatomic, strong) NSString <Optional>*expertName; // 专家姓名
@property (nonatomic, strong) NSString <Optional>*orderNumber; // 资料id号
@property (nonatomic, strong) NSString <Optional>*healthFile; // 健康档案名称
@property (nonatomic, strong) NSString <Optional>*symptom; // 症状
@property (nonatomic, strong) NSString <Optional>*desDetails; // 描述详情
@property (nonatomic, strong) NSString <Optional>*help; // 问题
@property (nonatomic, strong) NSString <Optional>*patientID; // 患者ID
@property (nonatomic, strong) NSString <Optional>*orderState; // 订单状态(0:未支付, 1:已支付)0=待审核 1=审核通过 2=已确认时间 3=已完成4=已取消,5=爽约,6=拒接7=退款申请中8=退款已审核 9=已退款,10=已关闭,11=订单已完成
@property (nonatomic, strong) NSString <Optional>*payTime; // 支付时间
@property (nonatomic, strong) NSString <Optional>*expertAnswer; // 专家回答
@property (nonatomic, strong) NSString <Optional>*patientName; // 患者名称
@property (nonatomic, strong) NSString <Optional>*phone; // 联系电话
@property (nonatomic, strong) NSString <Optional>*expectStartTime; // 期望联系开始时间
@property (nonatomic, strong) NSString <Optional>*expectEndTime; // 期望联系结束时间
@property (nonatomic, strong) NSString <Optional>*expectTime; // 预约时间

@property (nonatomic, strong) NSString <Optional>*actualStartTime; // 实际联系开始时间
@property (nonatomic, strong) NSString <Optional>*actualEndTime; // 实际联系结束时间
@property (nonatomic, strong) NSString <Optional>*actualTime; // 实际预约时间

@property (nonatomic, strong) NSString <Optional>*hospital; // 专家医院
@property (nonatomic, strong) NSString <Optional>*department; // 专家科室


@end
