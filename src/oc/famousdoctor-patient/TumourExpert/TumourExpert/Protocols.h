//
//  Protocols.h
//  TumourExpert
//
//  Created by 吴玉龙 on 14-5-6.
//  Copyright (c) 2014年 SINO HEALTHNET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TEAskModel.h"
#import "TEOrderModel.h"
#import "TEChoosePatientViewController.h"
#import "TEChoosePatientDataViewController.h"
#import "TEChoosePayModeViewController.h"
#import "TEReusableTextFieldViewController.h"
#import "TEReusableTextViewViewController.h"
#import "TEAddPatientViewController.h"
#import "TERegisterConfirmViewController.h"
#import "TEUserModel.h"
#import "TESeekAreaViewController.h"
#import "TESeekDiseaseViewController.h"
#import "TESeekHospitalViewController.h"
#import "TEConfirmConsultViewController.h"
#import "TEOfflineConsultViewController.h"
#import "TECompleteConsultDetailsViewController.h"
#import "TEPaymentConsultDetailsViewController.h"
#import "TEEditConsultDetailsViewController.h"


// 登录
@protocol TELoginViewControllerProtocol <NSObject>
@end

// 注册
@protocol TERegisterViewControllerProtocol <NSObject>
@end

// 注册验证
@protocol TERegisterConfirmViewControllerProtocol <NSObject>
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *password;
@end

// 重置密码
@protocol TEResetPasswordViewControllerProtocol <NSObject>
@end

// 注册协议
@protocol TEAgreementViewControllerProtocol <NSObject>
@end

// 首页
@protocol TEHomeViewControllerProtocol <NSObject>
@end

// 首页推荐专家列表
@protocol TEHomeRecommendExpertListViewControllerProtocol <NSObject>
@end

// 首页健康资讯列表
@protocol TEHomeHealthInfoListViewControllerProtocol <NSObject>
@end

// 首页专家专栏列表
@protocol TEHomeExpertColumnListViewControllerProtocol <NSObject>
@end

// 搜索结果
@protocol TESearchResultViewControllerProtocol <NSObject>
@property (nonatomic, strong) NSString *keyword;  // 关键字
@property (nonatomic, strong) NSString *searchType; // 搜索类型
@property (nonatomic, strong) NSString *searchId; // 搜索Id
@end

// 肿瘤疾病
@protocol TETumourViewControllerProtocol <NSObject>
@end

// 找专家里的地区
@protocol TESeekAreaViewControllerProtocol <NSObject>
@property (nonatomic, weak) id <TESeekAreaViewControllerDelegate> delegate;
@end

// 找专家里的肿瘤疾病
@protocol TESeekDiseaseViewControllerProtocol <NSObject>
@property (nonatomic, weak) id <TESeekDiseaseViewControllerDelegate> delegate;
@end

// 找专家里的医院
@protocol TESeekHospitalViewControllerProtocol <NSObject>
@property (nonatomic, weak) id <TESeekHospitalViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *province;
@end

// 疾病详情
@protocol TETumourDetailViewControllerProtocol <NSObject>
@property (nonatomic, strong) NSString *diseaseId; // 疾病ID
@property (nonatomic, strong) NSString *name; // 疾病中文名
@end

// 找专家
@protocol TEExpertViewControllerProtocol <NSObject>
@end

// 专家详情
@protocol TEExpertDetailViewControllerProtocol <NSObject>
@property (nonatomic, strong) NSString *expertId; // 专家id
@end

// 专家栏目
@protocol TEExpertColumnViewControllerProtocol <NSObject>
@property (nonatomic, strong) NSString *expertId; // 专家Id
@end

// 专家文章
@protocol TEExpertArticleViewControllerProtocol <NSObject>
@property (nonatomic, strong) NSString *articleId; // 文章id
@end

// 网络咨询
@protocol TETextConsultViewControllerProtocol <NSObject>
@property (nonatomic, strong) NSString *expertId; // 专家id
@end

// 电话咨询
@protocol TEPhoneConsultViewControllerProtocol <NSObject>
@property (nonatomic, strong) NSString *expertId; // 专家id
@end

// 面对面咨询
@protocol TEOfflineConsultViewControllerProtocol <NSObject>
@property (nonatomic, strong) NSString *expertId; // 专家id
@end


// 确定咨询
@protocol TEConfirmConsultViewControllerProtocol <NSObject>
@property (nonatomic, strong) NSString *expertName; // 专家id
@property (nonatomic, strong) NSMutableArray *healthFiles;
@property (nonatomic, strong) NSMutableArray *selectHealthFiles;
@property (nonatomic, strong) NSString *phone; // 电话
@property (nonatomic, strong) NSString *patientName; // 患者
@property (nonatomic, strong) NSString *patientId; // 患者Id
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, strong) NSString *question;
@property (nonatomic, strong) NSString *symptom;
@property (nonatomic, strong) NSString *detailDesc;
@property (nonatomic, strong) NSString *help;
@property (nonatomic, assign) int TEConfirmConsultType;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *doctorId;
@property (nonatomic, strong) NSString *proid; //产品ID
@end

// 选择患者
@protocol TEChoosePatientViewControllerProtocol <NSObject>
@property (nonatomic, assign) id<TEChoosePatientViewControllerDelegate> delegate;
@end

// 选择患者资料
@protocol TEChoosePatientDataViewControllerProtocol <NSObject>
@property (nonatomic, assign) id<TEChoosePatientDataViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *consultType; // 咨询类型
@property (nonatomic, strong) NSString *patientId; // 患者Id
@end

// 选择支付方式
@protocol TEChoosePayModeViewControllerProtocol <NSObject>
@property (nonatomic, assign) id<TEChoosePayModeViewControllerDelegate> delegate;
@end

// 订单提交
@protocol TEOrderSubmitViewControllerProtocol <NSObject>
@property (nonatomic, strong) TEAskModel *askModel;
@property (nonatomic, strong) NSString *consultType;
@property (nonatomic, strong) NSString *patientId;
@property (nonatomic, strong) NSString *patientDataId;
@end


// 订单成功
@protocol TEOrderSuccessViewControllerProtocol <NSObject>
@property (nonatomic, strong)TEOrderModel *orderModel;
@property (nonatomic, assign) int TEConfirmConsultType;
@property (nonatomic, copy) NSString *patientName; // 患者
@property (nonatomic, strong) NSString *patientId; // 患者Id
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, strong) NSString *payType;
@end

// 支付成功
@protocol TEPaySuccessViewControllerProtocol <NSObject>
@property (nonatomic, assign) int TEConfirmConsultType;
@end

// 支付失败
@protocol TEPayFailureViewControllerProtocol <NSObject>
@end

// 支付信息
@protocol TEPayInfoViewControllerProtocol <NSObject>
@property (nonatomic, copy) NSString *payStatue;
@property (nonatomic, copy) NSString *payTime;
@property (nonatomic, copy) NSString *payPrice;
@property (nonatomic, copy) NSString *payModeName;
@end

// 分诊医生
@protocol TETriageViewControllerProtocol <NSObject>
@end

// 即时聊天
@protocol TETriageChatViewControllerProtocol <NSObject>
@end

// 个人中心
@protocol TEPersonalViewControllerProtocol <NSObject>
@end

// 个人资料
@protocol TEPersonalDataViewControllerProtocol <NSObject>
@end

// 编辑个人资料
@protocol TEEditPersonalDataViewControllerProtocol <NSObject>
@property (strong, nonatomic) TEUserModel *userModel;
@end


// 修改密码
@protocol TEModifyPasswordViewControllerProtocol <NSObject>
@end

// 订单管理
@protocol TEOrderViewControllerProtocol <NSObject>
@end

// 我的咨询
@protocol TEMyConsultViewControllerProtocol <NSObject>
@end

// 网络咨询、电话咨询、线下咨询
@protocol TEConsultViewControllerProtocol <NSObject>
@property (nonatomic, strong) NSString *consultType; // 咨询类型
@end

// 网络咨询详情
@protocol TETextConsultDetailViewControllerProtocol <NSObject>
@property (nonatomic, strong) NSString *consultType; // 咨询类型
@property (nonatomic, strong) NSString *consultId; // 咨询Id
@property (nonatomic, strong) NSString *expertName; // 专家姓名
@end

// 电话咨询详情
@protocol TEPhoneConsultDetailViewControllerProtocol <NSObject>
@property (nonatomic, strong) NSString *consultType; // 咨询类型
@property (nonatomic, strong) NSString *consultId; // 咨询Id
@end

// 线下咨询详情
@protocol TEReferralDetailViewControllerProtocol <NSObject>
@property (nonatomic, strong) NSString *consultType; // 咨询类型
@property (nonatomic, strong) NSString *consultId; // 咨询Id
@end

// 咨询问题
@protocol TEConsultQuestionViewControllerProtocol <NSObject>
@property (nonatomic, strong) NSString *consultId; // 咨询Id
@property (nonatomic, strong) NSString *nextQuestion; // 咨询的是第几个问题
@end

// 患者管理
@protocol TEPatientViewControllerProtocol <NSObject>
@end

// 新增患者
@protocol TEAddPatientViewControllerProtocol <NSObject>
@end

// 编辑患者
@protocol TEEditPatientViewControllerProtocol <NSObject>
@property (nonatomic, strong) NSString *patientId; // 患者id
@property (nonatomic, strong) NSString *archiveNumber; // 档案号
@end

// 健康档案详情
@protocol TEHealthArchiveDetailViewControllerProtocol <NSObject>
@property (nonatomic, strong) NSString *patientId; // 患者Id
@end


// 患者资料
@protocol TEPatientDataViewControllerProtocol <NSObject>
@property (nonatomic, strong) NSString *patientId; // 患者Id
@end

// 患者资料预览
@protocol TEPatientDataPreviewViewControllerProtocol <NSObject>
@property (nonatomic, strong) NSString *patientId; // 患者Id
@property (nonatomic, strong) NSString *patientDataId; // 患者资料id
@end

// 患者基本资料
@protocol TEPatientBasicDataViewControllerProtocol <NSObject>
@property (nonatomic, strong) NSString *patientId; // 患者id
@end

// 患者病历资料
@protocol TEPatientMedicalDataViewControllerProtocol <NSObject>
@property (nonatomic, strong) NSString *consultType; // 咨询类型
@property (nonatomic, strong) NSString *patientId; // 患者id
@property (nonatomic, strong) NSString *patientDataId; // 患者资料id
@end

// 主要咨询问题
@protocol TEBriefConsultQuestionViewControllerProtocol <NSObject>
@property (nonatomic, strong) NSString *consultType; // 咨询类型
@property (nonatomic, strong) NSString *patientId; // 患者id
@property (nonatomic, strong) NSString *patientDataId; // 患者资料id
@end

// 补充资料
@protocol TESupplementDataViewControllerProtocol <NSObject>
@property (nonatomic, strong) NSString *patientDataId; // 患者资料id
@end

// 意见反馈
@protocol TEFeedbackViewControllerProtocol <NSObject>
@end

// 设置
@protocol TESettingViewControllerProtocol <NSObject>
@end

// 关于我们
@protocol TEAboutUsViewControllerProtocol <NSObject>
@end

// 可重用的TextField页面
@protocol TEReusableTextFieldViewControllerProtocol
@property (nonatomic, strong) NSString *flag;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, assign) NSInteger keyboardType;
@property (nonatomic, assign) id <TEReusableTextFieldViewControllerDelegate> delegate;
@end

// 可重用的TextView页面
@protocol TEReusableTextViewViewControllerProtocol
@property (nonatomic, strong) NSString *flag;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) NSString *exampleContent;
@property (nonatomic, assign) id <TEReusableTextViewViewControllerDelegate> delegate;
@end

// 咨询完成详情
@protocol TECompleteConsultDetailsViewControllerProtocol <NSObject>
@property (nonatomic, strong) NSString *orderNumber; //订单号
@property (nonatomic, assign) int TEConfirmConsultType;
@end

// 咨询未付款详情
@protocol TEPaymentConsultDetailsViewControllerProtocol <NSObject>
@property (nonatomic, assign) int TEConfirmConsultType;
@property (nonatomic, copy) NSString *patientName; // 患者
@property (nonatomic, strong) NSString *patientId; // 患者Id
@property (nonatomic, strong) NSString *orderNumber; //订单号
@end


// 咨询编辑详情
@protocol TEEditConsultDetailsViewControllerProtocol <NSObject>
@property (nonatomic, assign) int TEConfirmConsultType;
//@property (nonatomic, copy) NSString *patientName; // 患者
//@property (nonatomic, strong) NSString *patientId; // 患者Id
//@property (nonatomic, copy) NSString *orderNumber;
//@property (nonatomic, copy) NSString *consultState;
//@property (nonatomic, copy) NSString *expectStartTime;
//@property (nonatomic, copy) NSString *expectEndTime;
//@property (nonatomic, strong) NSMutableArray *selectHealthFiles;
@property (nonatomic, strong) TEOrderDetailsModel *orderDetails;
@property (nonatomic, strong) NSString *orderNumber; //订单号
@end

// 科室下的专家
@protocol TEExpertOfDepartmentViewControllerProtocol <NSObject>
@property (nonatomic, strong) NSString *departmentId; // 科室Id
@end

@protocol TEHealthInfoViewControllerProtocol <NSObject>
@property (nonatomic, strong) NSString *healthInfoId; // 资讯id
@end
