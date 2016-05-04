//
//  MYSDiseases.h
//  MYSPatient
//
//  Created by 闫文波 on 15-2-4.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"
#import "MYSDiseaseModel.h"

@interface MYSDiseases : JSONModel
@property (nonatomic, assign) int total; // 总数
@property (nonatomic, strong) NSArray<MYSDiseaseModel> *diseases; // 疾病
@end
