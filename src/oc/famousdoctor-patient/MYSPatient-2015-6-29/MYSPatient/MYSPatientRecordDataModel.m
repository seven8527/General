//
//  MYSPatientRecordDataModel.m
//  MYSPatient
//
//  Created by 闫文波 on 15-3-2.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSPatientRecordDataModel.h"

@implementation MYSPatientRecordDataModel
+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"fileId": @"businessId",
                                                       @"filePath": @"filePath",
                                                       @"fileType": @"fileType"
                                                       }];
}
@end
