//
//  MYSBriefAnswerModel.h
//  MYSPatient
//
//  Created by 吴玉龙 on 15-3-24.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//  医生回复

#import "JSONModel.h"

@interface MYSBriefAnswerModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *addTime; // 主问回复添加时间
@property (nonatomic, copy) NSString<Optional> *content; // 主问回复内容
@property (nonatomic, copy) NSString<Optional> *doctorID; // 医生ID
@property (nonatomic, copy) NSString<Optional> *pfID; // 问题ID
@property (nonatomic, copy) NSString<Optional> *pfrID; // 回复ID
@property (nonatomic, copy) NSString<Optional> *state; //
@property (nonatomic, copy) NSString<Optional> *consultType; // 咨询类型 0主问  1 追问
@end
