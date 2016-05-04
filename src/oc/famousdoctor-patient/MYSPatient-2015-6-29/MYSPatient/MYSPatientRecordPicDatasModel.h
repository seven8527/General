//
//  MYSPatientRecordPicDatasModel.h
//  MYSPatient
//
//  Created by 闫文波 on 15-3-2.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"
#import "MYSPatientRecordDataModel.h"
@protocol MYSPatientRecordPicDatasModel @end

@interface MYSPatientRecordPicDatasModel : JSONModel
@property (nonatomic, strong) NSArray<MYSPatientRecordDataModel> *attList;
@end
