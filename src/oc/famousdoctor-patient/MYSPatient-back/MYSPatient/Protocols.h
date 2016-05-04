//
//  Protocols.h
//  MYSPatient
//
//  Created by 闫文波 on 15-1-4.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "MYSSettingViewController.h"
#import "MYSPersonalPatientBasicDataModel.h"
#import "MYSDiseaseModel.h"
#import "MYSDoctorHomeDynamicModel.h"
#import "MYSDoctorHomeIntroducesModel.h"
#import "MYSExpertGroupPatientModel.h"
#import "MYSPatientRecordModel.h"
#import "MYSExpertGroupAskModel.h"
#import "MYSUserModel.h"
#import "MYSPersonalChangePhoneNumberViewController.h"
#import "MYSPersonalPatientRecordDataModel.h"
#import "MYSUserGuideViewController.h"
#import "MYSLoginViewController.h"
#import "MYSRegisterViewController.h"

// 首页
@protocol MYSHomeViewControllerProtocol <NSObject>

@end

// banner
@protocol MYSBannerViewControllerProtocol <NSObject>
@property (nonatomic, copy) NSString *contentUrl;
@end

// 搜索
@protocol MYSSearchViewControllerProtocol <NSObject>

@end


// 名医汇
@protocol MYSExpertGroupViewControllerProtocol <NSObject>

@end

// 主任医师团
@protocol MYSDirectorGroupViewControllerProtocol <NSObject>

@end

//免费咨询
@protocol MYSDirectorGroupFreeConsultViewControllerProtocol <NSObject>


@end


// 名医圈医生主页
@protocol MYSExpertGroupDoctorHomeViewControllerProtocol <NSObject>
//@property (nonatomic, strong) id model;
@property (nonatomic, copy) NSString *doctorId;
@property (nonatomic, copy) NSString *doctorType; // 医生类型
@end


// 名医圈医生主页动态详情
@protocol MYSExpertGroupDynamicDetailsViewControllerProtocol <NSObject>
@property (nonatomic, copy) NSString *dynamicId; // 动态id
@property (nonatomic, strong) MYSDoctorHomeIntroducesModel *introducesModel; // 医生信息model
@end

// 名医圈医生主页案例详情
@protocol MYSExpertGroupRecordDetailsViewControllerProtocol <NSObject>
@property (nonatomic, strong) id model;
@end

// 名医网络咨询
@protocol MYSExpertGroupNetworkConsultViewControllerProtocol <NSObject>
@property (nonatomic, copy) NSString *doctorId;
@end

// 名医网络咨询确认
@protocol MYSExpertGroupConfirmNetworkConsultViewControllerProtocol <NSObject>
@property (nonatomic, strong) MYSExpertGroupPatientModel *patientModel;
@property (nonatomic, strong) MYSExpertGroupAskModel *askModel;
@property (nonatomic, copy) NSString *symptom; // 症状
@property (nonatomic, copy) NSString *situation; // 就医情况
@property (nonatomic, copy) NSString *help; // 何种帮助
@property (nonatomic, copy) NSString *phone; // 电话
@property (nonatomic, strong) NSArray *recordArray; // 就诊记录
@property (nonatomic, copy) NSString *consultType; // 咨询类型
@property (nonatomic, copy) NSString *consultStartTime; // 咨询开始时间
@property (nonatomic, copy) NSString *consultEndTime; // 咨询结束时间
@end

// 名医电话咨询
@protocol MYSExpertGroupPhoneConsultViewControllerProtocol <NSObject>
@property (nonatomic, copy) NSString *doctorId;
@end

// 名医面对面咨询
@protocol MYSExpertGroupOfflineConsultViewControllerProtocol <NSObject>
@property (nonatomic, copy) NSString *doctorId;
@end


// 选择用户代理
@protocol MYSExpertGroupConsultChooseUserViewControllerDelegate <NSObject>
@optional
- (void)expertGroupConsultChooseUserViewControllerDidSelected:(MYSExpertGroupPatientModel *)patientModel;

- (void)expertGroupConsultChooseUserViewControllerDidSelectedIndex:(NSInteger)patientIndex;
@end

// 选择用户
@protocol MYSExpertGroupConsultChooseUserViewControllerProtocol <NSObject>
@property (nonatomic, weak) id <MYSExpertGroupConsultChooseUserViewControllerDelegate> delegate;
@end

// 选择就诊记录
@protocol MYSExpertGroupConsultChooseMedicalRecordsViewControllerDelegate <NSObject>
- (void)expertGroupConsultChooseMedicalRecordsDidSelectedMedicalRecordModel:(id )medicalRecordModel;
@end


// 详细描述代理
@protocol MYSExpertGroupDetailsDescriptionViewControllerDelegate <NSObject>
- (void)expertGroupDetailsDescriptionViewSavedWithContentStr:(NSString *)contentStr withMark:(int)mark;
@end

// 详细描述
@protocol MYSExpertGroupDetailsDescriptionViewControllerProtocol <NSObject>
@property (nonatomic, copy) NSString *tipText;
@property (nonatomic, assign) int mark; // 标记 1 症状及体征 2 就医情况 3 何种帮助
@property (nonatomic, copy) NSString *contentStr; // 内容
@property (nonatomic, weak) id <MYSExpertGroupDetailsDescriptionViewControllerDelegate> delegate;
@end


// 选择就医记录
@protocol MYSExpertGroupConsultChooseMedicalRecordsViewControllerProtocol <NSObject>
@property (nonatomic, weak) id <MYSExpertGroupConsultChooseMedicalRecordsViewControllerDelegate> delegate;
@property (nonatomic, strong) MYSExpertGroupPatientModel *patientModel;
@end


// 新增就医记录
@protocol MYSExpertGroupConsultAddNewRecordViewControllerProtocol <NSObject>
@property (nonatomic, strong) MYSExpertGroupPatientModel *patientModel;
@end

// 新增就医记录
@protocol MYSExpertGroupConsultAddNewRecordDataViewControllerProtocol <NSObject>
@property (nonatomic, strong) MYSExpertGroupPatientModel *patientModel; // 患者id
//@property (nonatomic, copy) NSString *time;
//@property (nonatomic, copy) NSString *hospital;
//@property (nonatomic, copy) NSString *keshi;
//@property (nonatomic, copy) NSString *zhenduan;
@property (nonatomic, strong) NSString *patientDataId; // 患者资料id
@end


// 支付成功
@protocol MYSExpertGroupPaySuccessViewrProtocol <NSObject>
@property (nonatomic, copy) NSString *orderId; // 订单号
@property (nonatomic, copy) NSString *consultType; // 咨询类型
@property (nonatomic, copy) NSString *doctorPic; // 医生头像
@property (nonatomic, strong) UIImage *patientImage; // 患者头像
@end

// 支付失败
@protocol MYSExpertGroupPayFailureViewProtocol <NSObject>
@end

// 疾病大全
@protocol MYSDiseasesViewControllerProtocol <NSObject>

@end


// 健康档案
@protocol MYSHealthRecordsViewControllerProtocol <NSObject>

@end

// 健康档案 血压
@protocol MYSHealthRecordsBloodPressureViewControllerProtocol <NSObject>

@end


// 健康档案 血压列表
@protocol MYSHealthRecordsBloodPressureListViewControllerProtocol <NSObject>

@end


// 健康档案 血糖
@protocol MYSHealthRecordsBloodGlucoseViewControllerProtocol <NSObject>

@end

// 健康档案 血糖列表
@protocol MYSHealthRecordsBloodGlucoseListViewControllerProtocol <NSObject>

@end


// 健康档案 体重
@protocol MYSHealthRecordsWeightViewControllerProtocol <NSObject>

@end

// 健康档案 体重列表
@protocol MYSHealthRecordsWeightListViewControllerProtocol <NSObject>

@end

// 疾病详情
@protocol MYSDiseaseDetailsViewControllerProtocol <NSObject>
//@property (nonatomic, strong) MYSDiseaseModel *diseaseModel;
@property (nonatomic, copy) NSString *diseaseId;
@end



// 个人中心
@protocol MYSPersonalViewControllerPrototol <NSObject>

@end

// 个人中心查看订单
@protocol MYSPersonalCheckOrderDetailsViewControllerPrototol <NSObject>
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *consultType;
@property (nonatomic, copy) NSString *doctorPic; // 医生头像
@property (nonatomic, strong) UIImage *patientImage; // 患者头像
@end
// 个人中心查看就诊记录
@protocol MYSPersonalCheckMedicalRecordViewControllerPrototol <NSObject>
@property (nonatomic, strong) MYSExpertGroupPatientModel *patientModel;
@property (nonatomic, copy) NSString *medicalId;
@property (nonatomic, copy) NSString *orderNumber;
@end

// 个人中心编辑就诊记录
@protocol MYSPersonalEditMedicalRecordViewControllerPrototol <NSObject>
@property (nonatomic, copy) NSString *recordID; // 就诊记录ID
@property (nonatomic, strong) MYSPersonalPatientRecordDataModel *patientRecordModel;
@property (nonatomic, strong) MYSExpertGroupPatientModel *patientModel;
@end


// 个人中心免费咨询详情
@protocol MYSPersonalFreeConsultationDetailsViewControllerProtocol <NSObject>
@property (nonatomic, copy) NSString *pfid;
@end

// 个人中心账号管理代理
@protocol MYSPersonalAccountManagerViewDelegate <NSObject>
- (void)personalAccountManagerChangeInfo;
@end

// 个人中心账号管理
@protocol MYSPersonalAccountManagerViewControllerPrototol <NSObject>
@property (nonatomic, strong) MYSUserModel *userModel;
@property (nonatomic, strong) UIImage *iconImage;
@property (nonatomic, weak) id <MYSPersonalAccountManagerViewDelegate> delegate;
@end

// 个人中心更换手机号
@protocol MYSPersonalChangePhoneNumberViewControllerProtocol <NSObject>
@property (nonatomic, weak) id <MYSPersonalChangePhoneNumberViewControllerDelegate> delegate;
@end

// 个人中心修改密码
@protocol MYSPersonalChangePasswordViewControllerProtocol <NSObject>

@end



// 登录
@protocol MYSLoginViewControllerProtocol <NSObject>
@property (nonatomic, strong) Class source; // 来源
@property (nonatomic, assign) SEL aSelector; // 方法
@property (nonatomic, strong) id instance; // 实例
@property (nonatomic, assign) BOOL isHiddenRegisterButton; // 是否隐藏注册按钮

@property (nonatomic, weak) id <MYSLoginViewControllerDelegate> delegate;
@end


// 注册
@protocol MYSRegisterViewControllerProtocol <NSObject>
@property (nonatomic, assign) BOOL isGuidePortal; // 是否从引导页过来的
@property (nonatomic, weak) id <MYSRegisterViewControllerDelegate> delegate;
@end


// 找回密码
@protocol MYSFindPassWordViewControllerProtocol <NSObject>

@end


// 找回密码
@protocol MYSAgreementViewControllerProtocol <NSObject>

@end

// 更多
@protocol MYSMoreViewControllerProtocol <NSObject>

@end

// 意见反馈
@protocol MYSFeedBackViewControllerProtocol <NSObject>

@end

// 关于我们
@protocol MYSAboutUsViewControllerProtocol <NSObject>

@end

// 设置
@protocol MYSSettingViewControllerProtocol <NSObject>
@property (nonatomic, weak) id <MYSSettingViewControllerDelegate> delegate;
@end

@protocol MYSUserGuideViewControllerProtocol <NSObject>
@property (nonatomic, weak) id <MYSUserGuideViewControllerDelegate> delegate;
@end
