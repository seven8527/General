//
//  TEHospital.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-9-30.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"
#import "TEHospitalModel.h"

@interface TEHospital : JSONModel
@property (nonatomic, strong) NSArray<TEHospitalModel> *hospitals; // 医院
@end
