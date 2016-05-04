//
//  MYSDoctorHomeIntroducesModel.m
//  MYSPatient
//
//  Created by 吴玉龙 on 15-2-4.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSDoctorHomeIntroducesModel.h"

@implementation MYSDoctorHomeIntroducesModel

+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"uid": @"doctorId",
                                                       @"doctor_name": @"doctorName",
                                                       @"pic": @"headPortrait",
                                                       @"hospital": @"hospital",
                                                       @"department" : @"department",
                                                       @"clinical_title": @"qualifications",
                                                       @"attention": @"attentionNumber",
                                                       @"states": @"attentionState",
                                                       @"territory": @"territory",
                                                       @"introduce": @"introduce"
                                                       }];
}

@end
