//
//  TEDisease.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-6.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"
#import "TEDiseaseModel.h"

@interface TEDisease : JSONModel
@property (nonatomic, assign) int total; // 总数
@property (nonatomic, strong) NSArray<TEDiseaseModel> *diseases; // 疾病
@end

