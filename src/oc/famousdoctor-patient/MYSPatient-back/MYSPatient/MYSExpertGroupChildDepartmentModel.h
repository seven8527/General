//
//  MYSExpertGroupChildDepartmentModel.h
//  MYSPatient
//
//  Created by 闫文波 on 15-2-4.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

@protocol  MYSExpertGroupChildDepartmentModel @end

@interface MYSExpertGroupChildDepartmentModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *departmentName; // 子类科室名
@property (nonatomic, strong) NSString<Optional> *departmentID; // 子类科室id
@end
