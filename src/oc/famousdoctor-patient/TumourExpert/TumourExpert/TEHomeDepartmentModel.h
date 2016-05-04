//
//  TEHomeDepartmentModel.h
//  TumourExpert
//
//  Created by 闫文波 on 14-10-13.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

@protocol TEHomeDepartmentModel @end

@interface TEHomeDepartmentModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *depatmentId; // 科室ID
@property (nonatomic, strong) NSString<Optional> *departmentName; // 科室名字
@property (nonatomic, strong) NSString<Optional> *picUrl; // 默认图片路径
@property (nonatomic, strong) NSString<Optional> *picSelectUrl;  // 图片选中路径
@end
