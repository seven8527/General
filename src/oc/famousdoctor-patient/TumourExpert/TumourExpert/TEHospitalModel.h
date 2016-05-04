//
//  TEHospitalModel.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-16.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

@protocol TEHospitalModel @end

// 医院
@interface TEHospitalModel : JSONModel
@property (nonatomic, strong) NSString *hospitalId; // 医院ID
@property (nonatomic, strong) NSString *hospitalName; // 医院名称
@property (nonatomic, strong) NSString<Optional> *englishName;
@end
