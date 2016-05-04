//
//  MYSDoctorHome.h
//  MYSPatient
//
//  Created by 吴玉龙 on 15-2-4.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"
#import "MYSDoctorHomeIntroducesModel.h"
#import "MYSDoctorHomeDynamicModel.h"

@interface MYSDoctorHome : JSONModel
@property (nonatomic, strong) MYSDoctorHomeIntroducesModel<Optional> *introducesModel;
@property (nonatomic, strong) NSArray<MYSDoctorHomeDynamicModel> *dynamicArray;
@property (nonatomic, copy) NSString<Optional> *count;
@end
