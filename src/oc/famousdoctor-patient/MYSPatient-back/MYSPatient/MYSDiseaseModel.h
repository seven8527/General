//
//  MYSDiseaseModel.h
//  MYSPatient
//
//  Created by 闫文波 on 15-2-4.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

@protocol MYSDiseaseModel @end


// 疾病
@interface MYSDiseaseModel : JSONModel

@property (nonatomic, strong) NSString *diseaseId; // 疾病ID
@property (nonatomic, strong) NSString *name; // 疾病中文名
@property (nonatomic, strong) NSString<Optional> *englishName; // 疾病的英文名
@property (nonatomic, strong) NSString<Optional> *synopsis; // 简介
@property (nonatomic, strong) NSString<Optional> *pathogenesis; // 病因
@property (nonatomic, strong) NSString<Optional> *clinicalFeature; // 临床表现
@property (nonatomic, strong) NSString<Optional> *cure; // 治疗

@end
