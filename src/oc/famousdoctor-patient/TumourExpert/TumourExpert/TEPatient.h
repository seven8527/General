//
//  TEPatient.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-10.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"
#import "TEPatientModel.h"

// 患者
@interface TEPatient : JSONModel
@property (nonatomic, strong) NSArray<TEPatientModel> *patients;
@end

