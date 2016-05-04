//
//  TEPatientData.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-17.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"
#import "TEPatientDataModel.h"

@interface TEPatientData : JSONModel
@property (nonatomic, assign) int total;
@property (nonatomic, strong) NSArray<TEPatientDataModel> *patientDatas;
@end
