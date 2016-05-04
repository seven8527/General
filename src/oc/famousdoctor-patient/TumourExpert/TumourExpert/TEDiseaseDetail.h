//
//  TEDiseaseDetail.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-6-10.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"
#import "TEDiseaseModel.h"
#import "TEExpertModel.h"

@interface TEDiseaseDetail : JSONModel
@property (nonatomic, strong) TEDiseaseModel *disease; // 疾病
@property (nonatomic, strong) NSArray<TEExpertModel> *experts; // 专家
@end
