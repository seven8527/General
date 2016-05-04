//
//  MYSDoctorHomeDynamicDetailsModel.h
//  MYSPatient
//
//  Created by 闫文波 on 15-2-9.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "JSONModel.h"

@interface MYSDoctorHomeDynamicDetailsModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *doctorName; // 作者
@property (nonatomic, copy) NSString<Optional> *title; // 标题
@property (nonatomic, copy) NSString<Optional> *addTime; // 创建时间
@property (nonatomic, copy) NSString<Optional> *content; // 动态内容
@end
