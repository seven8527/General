//
//  MYSPersonalFreeConsultationFrame.h
//  MYSPatient
//
//  Created by 闫文波 on 15-3-23.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYSFreeConsult.h"

@interface MYSPersonalFreeConsultationFrame : NSObject
@property (nonatomic, assign) CGRect patientImageViewF;  // 患者头像
@property (nonatomic, assign) CGRect patientInfoLableF; // 患者资料
@property (nonatomic, assign) CGRect patientSexImageViewF; // 患者性别图标
@property (nonatomic, assign) CGRect consultStatusLabelF; // 回复状态
@property (nonatomic, assign) CGRect firstLineF; //  第一条线
@property (nonatomic, assign) CGRect questionLabelF; // 患者问题
@property (nonatomic, assign) CGRect doctorNameLabelF; // 专家姓名
@property (nonatomic, assign) CGRect doctorInfoLabelF; // 医生信息
@property (nonatomic, assign) CGRect replyImageViewF; // 回复背景
@property (nonatomic, assign) CGRect replyLabelF; // 回复内容
@property (nonatomic, assign) CGRect timeLabelF; // 咨询时间
@property (nonatomic, assign) CGRect timePicViewF; // 时间图标
@property (nonatomic, assign) CGRect replyButtonF; // 回复按钮
@property (nonatomic, assign) CGFloat CellHeight;
@property (nonatomic, assign) CGRect secondLineF; //  第二条线
@property (nonatomic, strong) MYSFreeConsult * freeConsultModel;
@end
