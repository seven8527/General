//
//  MYSExpertGroupPatientRecordDataModel.h
//  MYSPatient
//
//  Created by 闫文波 on 15-3-11.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

@protocol MYSExpertGroupPatientRecordDataModel @end

@interface MYSExpertGroupPatientRecordDataModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *vistingTime; // 就诊时间
@property (nonatomic, copy) NSString<Optional> *hospital; // 就诊医院
@property (nonatomic, copy) NSString<Optional> *department; // 就诊科室
@property (nonatomic, copy) NSString<Optional> *recordID; // 就诊记录id
@property (nonatomic, copy) NSString<Optional> *jianyandan; // 检验单 化验单
@property (nonatomic, copy) NSString<Optional> *binglidan; // 病历单
@property (nonatomic, copy) NSString<Optional> *other; //其他资料
@property (nonatomic, copy) NSString<Optional> *patientID; // 患者ID
@property (nonatomic, copy) NSString<Optional> *addData; // 添加日期
@property (nonatomic, copy) NSString<Optional> *recordTitle; // 病例标题
@property (nonatomic, copy) NSString<Optional> *diagnosis; // 诊断
@property (nonatomic, copy) NSString<Optional> *orderNumber; // 订单号
@end
