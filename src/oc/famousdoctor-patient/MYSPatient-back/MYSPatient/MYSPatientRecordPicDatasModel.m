//
//  MYSPatientRecordPicDatasModel.m
//  MYSPatient
//
//  Created by 闫文波 on 15-3-2.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSPatientRecordPicDatasModel.h"


@implementation MYSPatientRecordPicDatasModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"attList": @"attList"
                                                       }];
}
@end
