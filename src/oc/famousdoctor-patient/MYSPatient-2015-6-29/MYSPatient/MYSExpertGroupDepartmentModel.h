//
//  MYSExpertGroupDepartmentModel.h
//  MYSPatient
//
//  Created by 闫文波 on 15-2-4.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"
#import "MYSExpertGroupChildDepartmentModel.h"

@protocol MYSExpertGroupDepartmentModel @end

@interface MYSExpertGroupDepartmentModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *superDepartmentName; // 父类科室名
@property (nonatomic, strong) NSArray<MYSExpertGroupChildDepartmentModel> *childDepartmentArray; // 子科室集合
@property (nonatomic, strong) NSString<Optional> *superDepartmentID; // 父类科室ID
@end
