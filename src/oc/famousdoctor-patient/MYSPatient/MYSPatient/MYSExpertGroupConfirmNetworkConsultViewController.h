//
//  MYSExpertGroupConfirmNetworkConsultViewController.h
//  MYSPatient
//
//  Created by 闫文波 on 15-1-27.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import "MYSBaseViewController.h"
#import "MYSExpertGroupPatientModel.h"
#import "MYSExpertGroupAskModel.h"

@interface MYSExpertGroupConfirmNetworkConsultViewController : MYSBaseViewController
@property (nonatomic, strong) MYSExpertGroupPatientModel *patientModel;
@property (nonatomic, copy) NSString *symptom; // 症状
@property (nonatomic, copy) NSString *situation; // 就医情况
@property (nonatomic, copy) NSString *help; // 何种帮助
@property (nonatomic, copy) NSString *phone; // 电话
@property (nonatomic, strong) MYSExpertGroupAskModel *askModel;
@property (nonatomic, strong) NSArray *recordArray; //就诊记录
@property (nonatomic, copy) NSString *consultType; // 咨询类型
@property (nonatomic, copy) NSString *consultStartTime; // 咨询开始时间
@property (nonatomic, copy) NSString *consultEndTime; // 咨询结束时间
@end
