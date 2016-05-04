//
//  MYSDiseaseIntroductionModel.h
//  MYSPatient
//
//  Created by 闫文波 on 15-2-5.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

@protocol MYSDiseaseIntroductionModel @end

@interface MYSDiseaseIntroductionModel : JSONModel
@property (nonatomic, strong) NSString *diseaseID; // 疾病id
@property (nonatomic, strong) NSString<Optional> *title; // 疾病名称
@property (nonatomic, strong) NSString<Optional> *synopsis; // 简介
@property (nonatomic, strong) NSString<Optional> *pathogenesis; // 病因
@property (nonatomic, strong) NSString<Optional> *clinicalFeature; // 临床表现
@property (nonatomic, strong) NSString<Optional> *cure; // 治疗
@end
