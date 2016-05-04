//
//  MYSExpertGroupPatient.h
//  MYSPatient
//
//  Created by 闫文波 on 15-2-10.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"
#import "MYSExpertGroupPatientModel.h"
// 患者集合
@interface MYSExpertGroupPatient : JSONModel
@property (nonatomic, strong) NSArray<MYSExpertGroupPatientModel> *patients;
@end
