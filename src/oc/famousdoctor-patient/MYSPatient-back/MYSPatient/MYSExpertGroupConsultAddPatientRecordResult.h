//
//  MYSExpertGroupConsultAddPatientRecordResult.h
//  MYSPatient
//
//  Created by 闫文波 on 15-3-10.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"


// 添加就诊记录返回结果
@interface MYSExpertGroupConsultAddPatientRecordResult : JSONModel
@property (nonatomic, strong) NSString *state; // 服务器返回的状态码
@property (nonatomic, strong) NSString<Optional> *pmid;  // 资料Id
@property (nonatomic, strong) NSString<Optional> *pmname; // 资料名
@end
