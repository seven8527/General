//
//  TEPatientDataModel.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-17.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

@protocol TEPatientDataModel @end

// 患者
@interface TEPatientDataModel : JSONModel
@property (nonatomic, strong) NSString *patientId; // 患者Id
@property (nonatomic, strong) NSString *patientDataId; // 患者资料Id
@property (nonatomic, strong) NSString *patientDataName; // 患者资料名
@property (nonatomic, assign) int auditState; // 审核状态
@property (nonatomic, strong) NSString<Optional> *billno; // 订单号
@end
