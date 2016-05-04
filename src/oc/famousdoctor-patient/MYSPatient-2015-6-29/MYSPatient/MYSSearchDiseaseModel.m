//
//  MYSSearchDiseaseModel.m
//  MYSPatient
//
//  Created by 吴玉龙 on 15-2-2.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSSearchDiseaseModel.h"

@implementation MYSSearchDiseaseModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"did": @"diseaseId",
                                                       @"title": @"diseaseName"
                                                       }];
}

@end
