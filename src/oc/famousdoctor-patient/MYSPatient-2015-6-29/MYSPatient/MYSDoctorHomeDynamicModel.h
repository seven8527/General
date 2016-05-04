//
//  MYSDoctorHomeDynamicModel.h
//  MYSPatient
//
//  Created by 吴玉龙 on 15-2-4.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

// 名医生专家主页动态
@protocol MYSDoctorHomeDynamicModel @end

@interface MYSDoctorHomeDynamicModel : JSONModel
@property (nonatomic, strong) NSString<Optional> *dynamicId; // 动态id
@property (nonatomic, strong) NSString<Optional> *title; // 动态标题
@property (nonatomic, strong) NSString<Optional> *addTime; // 创建时间
@property (nonatomic, copy) NSString<Optional> *picurl; // 动态缩略图
@end
