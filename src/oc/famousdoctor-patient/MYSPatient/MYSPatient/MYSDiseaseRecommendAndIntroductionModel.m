//
//  MYSDiseaseRecommendAndIntroductionModel.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-5.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSDiseaseRecommendAndIntroductionModel.h"

@implementation MYSDiseaseRecommendAndIntroductionModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"disease": @"diseaseIntroductionModel",
                                                       @"disease_doctor": @"expertGroupDoctor",
                                                       @"pic_path": @"picpath"
                                                       }];
}

@end
