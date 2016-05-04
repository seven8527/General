//
//  MYSDiseaseModel.m
//  MYSPatient
//
//  Created by 闫文波 on 15-2-4.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSDiseaseModel.h"


@implementation MYSDiseaseModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"did": @"diseaseId",
                                                       @"title": @"name",
                                                       @"en_title": @"englishName",
                                                       @"introduce": @"synopsis",
                                                       @"aetiological": @"pathogenesis",
                                                       @"prevent": @"clinicalFeature",
                                                       @"treat": @"cure"
                                                       }];
}
@end
