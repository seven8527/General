//
//  TEPatientBasicDataModel.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-24.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

// 患者基本资料
@interface TEPatientBasicDataModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *patientId; // 患者Id
@property (nonatomic, strong) NSString<Optional> *name; // 就诊记录名称
@property (nonatomic, strong) NSString<Optional> *hospital; // 就医医院
@property (nonatomic, strong) NSString<Optional> *date; // 就诊日期
@property (nonatomic, strong) NSString<Optional> *keshi; // 就诊科室
@property (nonatomic, strong) NSString<Optional> *zhenduan; // 初步诊断

@property (nonatomic, strong) NSString<Optional> *jianyandan; // 检验单
@property (nonatomic, strong) NSString<Optional> *baogaodan; // 报告单
@property (nonatomic, strong) NSString<Optional> *qita; // 其他资料
@property (nonatomic, strong) NSString<Optional> *isContainHttp; // 图片地址是否包含http://

@end
