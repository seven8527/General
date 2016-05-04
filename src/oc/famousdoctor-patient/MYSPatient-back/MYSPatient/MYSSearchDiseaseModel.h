//
//  MYSSearchDiseaseModel.h
//  MYSPatient
//
//  Created by 吴玉龙 on 15-2-2.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

@protocol MYSSearchDiseaseModel @end

// 搜索结果--疾病的数据模型
@interface MYSSearchDiseaseModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *diseaseId; // 疾病id
@property (nonatomic, strong) NSString<Optional> *diseaseName; // 疾病名称
@end
