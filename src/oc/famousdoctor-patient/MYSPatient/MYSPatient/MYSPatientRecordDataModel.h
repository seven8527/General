//
//  MYSPatientRecordDataModel.h
//  MYSPatient
//
//  Created by 闫文波 on 15-3-2.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

@protocol MYSPatientRecordDataModel @end

@interface MYSPatientRecordDataModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *businessId; // 就诊记录id
@property (nonatomic, copy) NSString<Optional> *filePath; // 图片资料路径
@property (nonatomic, copy) NSString<Optional> *fileType; // 图片资料类型
@end
