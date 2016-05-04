//
//  MYSPersonalPatientBasicDataModel.h
//  MYSPatient
//
//  Created by 闫文波 on 15-2-3.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

// 患者基本资料  档案资料
@interface MYSPersonalPatientBasicDataModel : JSONModel

@property (nonatomic, strong) NSString<Optional> *patientId; // 患者Id
@property (nonatomic, strong) NSString<Optional> *name; // 就诊记录名称
@property (nonatomic, strong) NSString<Optional> *hospital; // 就医医院
@property (nonatomic, strong) NSString<Optional> *date; // 就诊日期
@property (nonatomic, strong) NSString<Optional> *keshi; // 就诊科室
@property (nonatomic, strong) NSString<Optional> *zhenduan; // 初步诊断

@property (nonatomic, strong) NSString<Optional> *jianyandan; // 检验单
@property (nonatomic, strong) NSString<Optional> *baogaodan; // 报告单
@property (nonatomic, strong) NSString<Optional> *qita; // 其他资料

@end
