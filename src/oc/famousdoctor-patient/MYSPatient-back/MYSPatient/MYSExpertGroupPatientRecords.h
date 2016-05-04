//
//  MYSExpertGroupPatientRecords.h
//  MYSPatient
//
//  Created by 闫文波 on 15-3-11.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"
#import "MYSExpertGroupPatientRecordDataModel.h"

@interface MYSExpertGroupPatientRecords : JSONModel
@property (nonatomic, strong) NSArray<MYSExpertGroupPatientRecordDataModel> *records;
@property (nonatomic, copy) NSString<Optional> *total;
@end
