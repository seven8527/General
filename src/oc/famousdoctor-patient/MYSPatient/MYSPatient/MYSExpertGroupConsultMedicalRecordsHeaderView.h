//
//  MYSExpertGroupConsultMedicalRecordsHeaderView.h
//  MYSPatient
//
//  Created by 闫文波 on 15-1-19.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MYSPatientRecordModel.h"
#import "MYSExpertGroupPatientRecordDataModel.h"

@protocol MYSExpertGroupConsultMedicalRecordsHeaderViewDelegate <NSObject>
@optional

// 或者选择的索引值
- (void)expertGroupConsultMedicalRecordDidSelectWithIndex:(NSInteger)index;

// 取消的索引值
- (void)expertGroupConsultMedicalRecordDidDeselectWithIndex:(NSInteger)index;
@end

@interface MYSExpertGroupConsultMedicalRecordsHeaderView : UIView
//@property (nonatomic, assign) BOOL isOpen;
//@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, weak) UIButton *checkButton; // 选择
@property (nonatomic, weak) UIImageView *indicatorView; // 指示
@property (nonatomic, weak) UIView *topLine;
@property (nonatomic, weak) UIView *bottomLine;
@property (nonatomic, weak) id <MYSExpertGroupConsultMedicalRecordsHeaderViewDelegate> delegate;
//@property (nonatomic, strong) MYSPatientRecordModel *patientRecordModel;
@property (nonatomic, strong) MYSExpertGroupPatientRecordDataModel *patientRecordModel;
@end
