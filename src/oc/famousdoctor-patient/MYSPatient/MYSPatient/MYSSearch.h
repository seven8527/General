//
//  MYSSearch.h
//  MYSPatient
//
//  Created by 吴玉龙 on 15-2-2.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"
#import "MYSSearchDoctorModel.h"
#import "MYSSearchDiseaseModel.h"

@interface MYSSearch : JSONModel
@property (nonatomic, strong) NSMutableArray<MYSSearchDoctorModel> *doctorArray;
@property (nonatomic, strong) NSString<Optional> *doctorTotal;
@property (nonatomic, strong) NSMutableArray<MYSSearchDiseaseModel> *diseaseArray;
@property (nonatomic, strong) NSString<Optional> *diseaseTotal;
@end
