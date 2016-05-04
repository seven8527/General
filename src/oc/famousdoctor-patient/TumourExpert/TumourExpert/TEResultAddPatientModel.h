//
//  TEResultAddPatientModel.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-10-10.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

// 增加患者返回的结果
@interface TEResultAddPatientModel : JSONModel
@property (nonatomic, strong) NSString *state; // 服务器返回的状态码
@property (nonatomic, strong) NSString<Optional> *patientId;  // 资料Id
@end
