//
//  MYSDiseaseIntroductionModel.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-5.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSDiseaseIntroductionModel.h"

@implementation MYSDiseaseIntroductionModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"did": @"diseaseID",
                                                       @"title": @"title",
                                                       @"introduce": @"synopsis",
                                                       @"aetiological": @"pathogenesis",
                                                       @"prevent": @"clinicalFeature",
                                                       @"treat": @"cure"
                                                       }];
}

@end
