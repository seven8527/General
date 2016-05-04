//
//  TEDiseaseModel.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-16.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

@protocol TEDiseaseModel @end

// 疾病
@interface TEDiseaseModel : JSONModel
@property (nonatomic, strong) NSString *diseaseId; // 疾病ID
@property (nonatomic, strong) NSString *name; // 疾病中文名
@property (nonatomic, strong) NSString<Optional> *englishName; // 疾病的英文名
@property (nonatomic, strong) NSString<Optional> *synopsis; // 简介
@property (nonatomic, strong) NSString<Optional> *pathogenesis; // 病因
@property (nonatomic, strong) NSString<Optional> *clinicalFeature; // 临床表现
@property (nonatomic, strong) NSString<Optional> *cure; // 治疗
@end
