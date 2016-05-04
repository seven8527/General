//
//  TEDiseaseModel.m
//  TumourExpert
//
//  Created by 吴玉龙 on 14-4-16.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "TEDiseaseModel.h"

@implementation TEDiseaseModel

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
