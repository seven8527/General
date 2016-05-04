//
//  MYSMedicalRecordCollectionHeaderView.h
//  MYSPatient
//
//  Created by 闫文波 on 15-1-29.
//  Copyright (c) 2015年 SINO HEALTHNET. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MYSMedicalRecordCollectionHeaderViewDelegate <NSObject>
@optional
- (void)medicalRecordCollectionHeaderViewDidSelectPatientWithModel:(id)model;

- (void)medicalRecordCollectionHeaderViewClickUserManager;

- (void)medicalRecordCollectionHeaderViewClickAddNewRecord;

@end

@interface MYSMedicalRecordCollectionHeaderView : UICollectionReusableView
@property (nonatomic, weak) id <MYSMedicalRecordCollectionHeaderViewDelegate> delegate;
@property (nonatomic, weak) UIButton *addNewRecordView;
@property (nonatomic, strong) NSArray *patientArray;
@end
