//
//  MYSExpertGroupDoctor.h
//  MYSPatient
//
//  Created by 吴玉龙 on 15-2-4.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"
#import "MYSExpertGroupDoctorModel.h"

@protocol MYSExpertGroupDoctor @end

@interface MYSExpertGroupDoctor : JSONModel
@property (nonatomic, strong) NSMutableArray<MYSExpertGroupDoctorModel> *doctorArray;
@property (nonatomic, strong) NSString<Optional> *doctorTotal;
@end
