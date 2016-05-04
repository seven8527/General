//
//  MYSExpertGroupDepartment.h
//  MYSPatient
//
//  Created by 闫文波 on 15-2-4.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"
#import "MYSExpertGroupDepartmentModel.h"

@interface MYSExpertGroupDepartment : JSONModel
@property (nonatomic, strong) NSString<Optional> *state; // 状态
@property (nonatomic, strong) NSMutableArray<MYSExpertGroupDepartmentModel> *departmentArray; // 科室集合
@end
