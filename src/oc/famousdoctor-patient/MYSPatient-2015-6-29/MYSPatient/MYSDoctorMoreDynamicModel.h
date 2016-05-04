//
//  MYSDoctorMoreDynamicModel.h
//  MYSPatient
//
//  Created by 闫文波 on 15-2-9.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

@interface MYSDoctorMoreDynamicModel : JSONModel
@property (nonatomic, strong) NSArray<MYSDoctorHomeDynamicModel> *dynamicModelArray;;
@end
