//
//  MYSSearchDoctor.h
//  MYSPatient
//
//  Created by 闫文波 on 15-2-3.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"
#import "MYSSearchDoctorModel.h"

@interface MYSSearchDoctor : JSONModel
@property (nonatomic, strong) NSMutableArray<MYSSearchDoctorModel> *doctorArray;
@property (nonatomic, strong) NSString<Optional> *doctorTotal;
@end
