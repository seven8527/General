//
//  TEPatientModel.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-16.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

@protocol TEPatientModel @end

// 患者
@interface TEPatientModel : JSONModel
@property (nonatomic, strong) NSString *patientId; // 患者ID
@property (nonatomic, strong) NSString *patientName; // 患者姓名

@end
