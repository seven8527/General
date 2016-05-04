//
//  MYSPlusAskModel.h
//  MYSPatient
//
//  Created by 吴玉龙 on 15-3-24.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//  追问

#import "JSONModel.h"
#import "MYSPlusAnswerModel.h"

@protocol MYSPlusAskModel @end

@interface MYSPlusAskModel : JSONModel
@property (nonatomic, copy) NSString<Optional> *addTime; // 追问添加时间
@property (nonatomic, copy) NSString<Optional> *doctorID; // 医生ID
@property (nonatomic, copy) NSString<Optional> *isReply; // 是否回复 0 未回复 1 已经回复
@property (nonatomic, copy) NSString<Optional> *pfID; // 问题ID
@property (nonatomic, copy) NSString<Optional> *pid; // 患者ID
@property (nonatomic, copy) NSString<Optional> *question; // 追问问题
@property (nonatomic, strong) MYSPlusAnswerModel<Optional> *answerModel; // 追问回复
@property (nonatomic, copy) NSString<Optional> *times; // 回复次数
@property (nonatomic, copy) NSString<Optional> *type; // 主文 追问类型 问题类型 0 主问 1 追问
@property (nonatomic, copy) NSString<Optional> *userID; // 用户ID
@property (nonatomic, copy) NSString<Optional> *view; //是否查看过 0 未查看 1 已查看

@end
